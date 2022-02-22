#Установка логирования
#Скачаем скрипт logging.sh и запустим его
wget https://raw.githubusercontent.com/evgeniy-romanov/logging/main/logging.sh
sh logging.sh

#Остановим Апаче и проверим есть ли папка с логами
systemctl stop httpd
ls -l /var/log/nginx/

#Обновляемся в браузере, что бы была ошибка nginx и проверим в логах
ls -l /var/log/nginx/
#Запускаем Апаче и идем в браузер ip:5601
systemctl start httpd
192.168.31.226:5601
#Создать
menu - discover - create index pattern 
name=weblogs*
Timestamp field=Timestamp field
create index pattern
#Снова идем в discover и создадим Dashboard
menu - discover
#Переходим во вкладку Dashboard
create new dashboard - create visualization
#График показывает частоту запросов wget в браузере
выбираем в поиске под веблогом request.keyword + (добавить) - Bar horizontal - Show dates last 24 hours
#сохраним visualization
save and return

#Создадим еще один Dashboard, который показывает коды ответов ошибок
create visualization
Bar Donat
#В правой панели вводим
slice by=response
size by=records
#сохраним visualization
save and return
