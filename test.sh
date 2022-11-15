#!/bin/bash

locate=$PWD
mark="y"

while [ $mark = "y" ]
do

	echo -n "Что Вы хотите сделать? (Начать с нуля (a); продолжить с создания второго конфиг. файла (b); продолжить с создания третьего конфиг. файла (c); начать генерацию сертификатов (d)) (a / b / c / d): "
	read answ
	
	if [ $answ = "a" ]
	then
		
		rm -rf /certs/
		mkdir -p /certs/csrs/ /certs/crts/ /certs/keys/ /certs/extensions/
		
		touch /certs/extensions/ext.conf
		cd /certs/extensions/
		
		echo -e '[ req ]' >> ext.conf
		echo -e '\ndefault_bits = 3072\ndefault_keyfile = prot_one.key\ndistinguished_name = req_distinguished_name\nattributes = req_attributes\nx509_extensions = v3_ca\nstring_mask = utf8only' >> ext.conf
		echo -e '\n[ req_distinguished_name ]' >> ext.conf
		echo -e '\ncountryName = Country Name (2 letter code)\ncountryName_default = RU\ncountryName_min = 2\ncountryName_max = 2\nstateOrProvinceName = Some state or province\nstateOrProvinceName_default = Moscow\nlocalityName = Locality Name (eg, city)\nlocalityName_default = Moscow\norganizationName = Organization Name (eg, org)\norganizationName_default = WorldSkills\norganizationalUnitName = Organizational Unit Name (eg, section)\norganizationalUnitName_default = IT\ncommonName = Common Name (eg, YOUR name)\ncommonName_default = CA\ncommonName_max = 64\nemailAddress = Email Address\nemailAddress_default = ca-support@demo.lab\nemailAddress_max = 40' >> ext.conf
		echo -e '\n[ req_attributes ]' >> ext.conf
		echo -e '\nchallengePassword = A challenge Password\nchallengePassword_min = 4\nchallengePassword_max = 20\nunstructuredName = An optionaly company name' >> ext.conf
		echo -e '\n[ v3_ca ]' >> ext.conf
		echo -e '\nauthorityKeyIdentifier = keyid,issuer\nbasicConstraints = CA:TRUE\nkeyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment, keyCertSign\nsubjectKeyIdentifier = hash\nsubjectAltName = @alt_names' >> ext.conf
		echo -e '\n[ alt_names ]' >> ext.conf
		
		
		echo -ne "\nВведите одним числом общее количество доменов для корневого сертификата: "
		read count
		num=0
		echo -e ' '
		
		while [ $count -gt 0 ]
		do
			num=$[$num + 1]
			
			echo -ne "Введите DNS.$num: "
			read dns
			
			echo -e "DNS.$num = $dns" >> ext.conf
			echo -e "DNS.$num = $dns\n"
			
			count=$[$count - 1]
		done
		
		answ="b"
	fi
	
	if [ $answ = "b" ]
	then
		echo -e "ПРЕДУПРЕЖДЕНИЕ: Если Вы создали неправильно предыдущий конфиг. файл, в дальнейшем будут ошибки!!!\n"
		cd /certs/extensions/
		rm -rf server.ext
		
		touch server.ext
		
		echo -e '\nauthorityInfoAccess = OCSP;URI:http://ocsp.my.host/\nauthorityKeyIdentifier = keyid,issuer\nbasicConstraints = critical, CA:FALSE\nkeyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment\nsubjectKeyIdentifier = hash\nsubjectAltName = @alt_names' >> server.ext
		
		echo -e '\n[ alt_names ]' >> server.ext
		
		echo -ne "Введите одним числом общее количество доменов для серверного сертификата: "
		
		read count
		num=0
		echo -e ' '
		
		while [ $count -gt 0 ]
		do
			num=$[$num + 1]
			
			echo -ne "Введите DNS.$num: "
			read dns
			
			echo -e "DNS.$num = $dns" >> server.ext
			echo -e "DNS.$num = $dns\n"
			
			count=$[$count - 1]
		done
		
		answ="c"
	fi
	
	if [ $answ = "c" ]
	then
		echo -e "ПРЕДУПРЕЖДЕНИЕ: Если Вы создали неправильно предыдущие конфиг. файлы, в дальнейшем будут ошибки!!!\n"
		cd /certs/extensions/
		rm -rf client.ext
		
		touch client.ext
		
		echo -e '\nauthorityKeyIdentifier = keyid,issuer\nbasicConstraints = CA:TRUE,pathlen:2\nkeyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment, keyCertSign\nsubjectKeyIdentifier = hash\nsubjectAltName = @alt_names' >> client.ext
		
		echo -e '\n[ alt_names ]' >> client.ext
		
		
		echo -ne "Введите одним числом общее количество доменов для промежуточного сертификата: "
		
		read count
		num=0
		echo -e ' '
		
		while [ $count -gt 0 ]
		do
			num=$[$num + 1]
			
			echo -ne "Введите DNS.$num: "
			read dns
			
			echo -e "DNS.$num = $dns" >> client.ext
			echo -e "DNS.$num = $dns\n"
			
			count=$[$count - 1]
		done
		
		answ="d"
	fi
	
	if [ $answ = "d" ]
	then
		echo -e "ПРЕДУПРЕЖДЕНИЕ: Если Вы создали неправильно предыдущие конфиг. файлы, в дальнейшем будут ошибки!!!\n"
		cd /certs/extensions/
	else
		echo -ne "Ошибка выполнения, начните сначала."
	fi

	echo -ne "\nХотите вернуться в начало? (y/n): "
	read mark		
	
	if [ $mark = "n" ]
	then
		$locate/test2.sh
		break
	fi
done
