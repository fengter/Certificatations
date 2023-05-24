#!/bin/bash
cd /certs/



echo -ne "\nСоздание закрытого ключа для корневого сертификата ...\nУкажите имя ключа (e.g. name.key): "
read nameK1

echo -ne "\nУкажите длину шифрования ключа (e.g. 1024): "
read length

echo -e "\nКлюч генерируется ..."

openssl genrsa -out keys/$nameK1 $length



echo -ne "\nСоздание и подписывание корневого сертификата ...\nУкажите имя сертификата (e.g. rootCert.crt): "
read nameCT1

echo -ne "\nУкажите кодировку шифрования (e.g. -sha256): "
read code

echo -ne "\nУкажите срок действия сертификата (в днях) (e.g. 365): "
read days

openssl req -x509 -new -key keys/$nameK1 $code -days $days -config extensions/ext.conf -out crts/$nameCT1



echo -ne "\nСоздание закрытого ключа для промежуточного сертификата ... \nУкажите имя ключа (e.g. name.key): "
read nameK2

echo -ne "\nУкажите длину шифрования ключа (e.g. 1024): "
read length

echo -e "\nКлюч генерируется ..."

openssl genrsa -out keys/$nameK2 $length



echo -ne "\nСоздание запроса на подпись ... \nУкажите имя запроса (e.g. name.csr): "
read nameCS1

echo -ne "\nУкажите кодировку шифрования (e.g. -sha256): "
read code

openssl req -new -newkey rsa:$length $code -nodes -key keys/$nameK2 -out csrs/$nameCS1

echo -e "\nСоздание запроса на подпись промежуточного сертификата завершён!"



echo -ne "\nЗапуск процесса подписи промежуточного сертификата ...\nУкажите имя промежуточного сертификата (e.g. name.crt): "
read nameCT2

echo -ne "\nУкажите срок действия промежуточного сертификата (в днях) (e.g. 365): "
read days

echo -ne "\nУкажите кодировку шифрования (e.g. -sha256): "
read code

echo -e "\nНачинается процесс подписи промежуточного сертификата ..."
openssl x509 -req -in csrs/$nameCS1 -CA crts/$nameCT1 -CAkey keys/$nameK1 -CAcreateserial -out crts/$nameCT2 -days $days $code -extfile extensions/client.ext

echo -e "\nПодпись промежуточного сертификата завершена!"



echo -ne "\nСоздание закрытого ключа для серверного сертификата ... \nУкажите имя ключа (e.g. name.key): "
read nameK3

echo -ne "\nУкажите длину шифрования ключа (e.g. 1024): "
read length

echo -e "\nКлюч генерируется ..."

openssl genrsa -out keys/$nameK3 $length



echo -ne "\nСоздание запроса на подпись ... \nУкажите имя запроса (e.g. name.csr): "
read nameCS2

echo -ne "\nУкажите кодировку шифрования (e.g. -sha256): "
read code

openssl req -new -newkey rsa:$length $code -nodes -key keys/$nameK3 -out csrs/$nameCS2

echo -e "\nСоздание запроса на подпись серверного сертификата завершён!"



echo -ne "\nЗапуск процесса подписи серверного сертификата ...\nУкажите имя промежуточного сертификата (e.g. name.crt): "
read nameCT3

echo -ne "\nУкажите срок действия серверного сертификата (в днях) (e.g. 365): "
read days

echo -ne "\nУкажите кодировку шифрования (e.g. -sha256): "
read code

echo -e "\nНачинается процесс подписи серверного сертификата ..."
openssl x509 -req -in csrs/$nameCS2 -CA crts/$nameCT2 -CAkey keys/$nameK2 -CAcreateserial -out crts/$nameCT3 -days $days $code -extfile extensions/server.ext

echo -e "\nПодпись серверного сертификата завершена!\nДальнейшая инструкция по выполнению задания находится в файле - (instruct.txt)"

touch instruct.txt

echo -e "Откройте файл: /etc/nginx/conf.d/iwtm.conf\nЗатем найдите 2 ключа - ssl_certificate и ssl_certificate_key\nВведите на место значения указанные ниже данные!" >> instruct.txt

echo -e "\n/certs/crts/$nameCT3\n/certs/keys/$nameK3" >> instruct.txt

echo -en "Хотите упаковать сертификаты в формат - pkcs12? (y/n): "
read answ

if [ $answ = "y" ]
then
	echo -e "\nУкажите имя упаковочного пакета (e.g. name.p12): "
	read namep
	openssl pkcs12 -export -in crts/$nameCT2 -inkey keys/$nameK2 -certfile crts/$nameCT1 -out $namep
	echo -e "\nУпаковка сертификатов была успешно завершена"
fi
