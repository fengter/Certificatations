#!/bin/bash
cd /certs/

echo -ne "\nСоздание корневого сертификата ...\nНазовите имя ключа (e.g. name.key): "
read name

echo -ne "\nНазовите длину шифрования ключа (e.g. 1024): "
read length

echo -ne "\nГенерируем ключ ..."
openssl genrsa -out keys/$name $length
