#logging.sh#Логирование
yum -y install java-openjdk-devel java-openjdk

cat <<EOF | sudo tee /etc/yum.repos.d/elasticsearch.repo 
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

#После добавления репо импортируем ключ GPG:
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
#Очистим и обновим свой индекс пакетов YUM.
yum clean all
yum makecache
#Установим и настроим Elasticsearch
yum -y install elasticsearch
#Подтвердим установку пакета.
rpm -qi elasticsearch
# Устанавливаем лимиты памяти для виртуальной машины Java
wget https://raw.githubusercontent.com/evgeniy-romanov/logging/main/jvm.options
mv /root/jvm.options /etc/elasticsearch/jvm.options.d/jvm.options
#Запустим и поставим в автозагрузку службу elasticsearch: 
systemctl enable elasticsearch.service && systemctl start elasticsearch.service && systemctl status elasticsearch.service
# Создадим тестовый индекс
curl -X PUT http://127.0.0.1:9200/mytest_index
# Установим kibana
yum -y install kibana
# Заменим конфигурационный файл kibana
wget https://raw.githubusercontent.com/evgeniy-romanov/logging/main/kibana.yml
mv /root/kibana.yml /etc/kibana/kibana.yml
# Запустим и поставим в автозагрузку службу kibana и добавим разрешение на соединение через порт 5601 в браундмауэре.
systemctl enable kibana && systemctl start kibana && systemctl status kibana
#Установим logstash filebeat auditbeat metricbeat packetbeat heartbeat-elastic
yum -y install logstash filebeat auditbeat metricbeat packetbeat heartbeat-elastic
#Пропишем конфигурационные файлы logstash config
wget https://raw.githubusercontent.com/evgeniy-romanov/logging/main/logstash.yml
mv /root/logstash.yml /etc/logstash/logstash.yml
wget https://raw.githubusercontent.com/evgeniy-romanov/logging/main/logstash-nginx-es.conf
mv /root/logstash-nginx-es.conf /etc/logstash/conf.d/logstash-nginx-es.conf
#Перезагрузим службу logstash.service
systemctl restart logstash.service && systemctl status logstash.service
#Заменим конфигурационный файл /etc/filebeat/filebeat.yml
wget https://raw.githubusercontent.com/evgeniy-romanov/logging/main/filebeat.yml
mv /root/filebeat.yml /etc/filebeat/filebeat.yml
#Перезагрузим службу
systemctl enable filebeat && systemctl restart filebeat && systemctl status filebeat
