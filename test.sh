#!/bin/bash

locate=$PWD
mark="y"

while [ $mark = "y" ]
do

	sleep 1
	echo -ne "\n\n\033[1mВыберите этап создания конфиг. файлов:\n---------------------------------------------------------------------------\n(a):\033[0m Начать с нуля;\n\n\033[1m(b):\033[0m Создание конфиг. файла для серверного сертификата;\n\n\033[1m(c):\033[0m Создание конфиг. файла для промежуточного сертификата;\n\n\033[1m(d):\033[0m Начать генерацию сертификатов.\033[1m\n---------------------------------------------------------------------------\n\n\nВаш ответ:  \033[0m"
	read answ
	
	if [ $answ = "a" ]
	then
		if [ -d /certs/ ]
		then	
			echo -en "\nХотите удалить директорию '/certs/'? \033[1m(y/n):\033[0m "
			read answ
			if [ $answ = "y" ]
			then
				rm -rf /certs/
			else
				cd /certs/
			fi
		else
			mkdir -p /certs/csrs/ /certs/crts/ /certs/keys/ /certs/extensions/	
		fi
			
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
		
		sleep 1
		echo -ne "\nВведите одним числом общее количество доменов для корневого сертификата: "
		read count
		num=0
		echo -e ' '
		
		while [ $count -gt 0 ]
		do
			num=$[$num + 1]
			
			sleep 1
			echo -ne "Введите \033[1mDNS.$num:\033[0m "
			read dns
			
			echo -e "DNS.$num = $dns" >> ext.conf
			echo -e "\033[1mDNS.$num\033[0m = $dns\n"
			
			count=$[$count - 1]
		done
		
		answ="b"
	fi
	
	if [ $answ = "b" ]
	then
		sleep 1
		echo -e "ПРЕДУПРЕЖДЕНИЕ: Если Вы создали неправильно предыдущий конфиг. файл, в дальнейшем будут ошибки!!!\n"
		sleep 1
		cd /certs/extensions/
		rm -rf server.ext
		
		touch server.ext
		
		echo -e '\nauthorityInfoAccess = OCSP;URI:http://ocsp.my.host/\nauthorityKeyIdentifier = keyid,issuer\nbasicConstraints = critical, CA:FALSE\nkeyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment\nsubjectKeyIdentifier = hash\nsubjectAltName = @alt_names' >> server.ext
		
		echo -e '\n[ alt_names ]' >> server.ext
		
		echo -ne "Введите одним числом общее количество доменов для серверного сертификата: "
		read count
		num=0
		
		sleep 1
		count2=3
		echo " "

		while [ $count2 -gt 0 ]
		do
			echo -e "\033[1mПРЕДУПРЕЖДЕНИЕ:\033[0m Важно указать существующее DNS-имя\033[1m($count2)\033[0m\n"
			count2=$(($count2-1))
			sleep 1
		done

		while [ $count -gt 0 ]
		do
			num=$[$num + 1]

			echo -ne "Введите \033[1mDNS.$num:\033[0m "
			read dns
			
			echo -e "DNS.$num = $dns" >> server.ext
			echo -e "\033[1mDNS.$num\033[0m = $dns\n"
			
			count=$[$count - 1]
		done
		
		answ="c"
	fi
	
	if [ $answ = "c" ]
	then
		sleep 1
		echo -e "ПРЕДУПРЕЖДЕНИЕ: Если Вы создали неправильно предыдущие конфиг. файлы, в дальнейшем будут ошибки!!!\n"
		sleep 1
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
			
			sleep 1
			echo -ne "Введите \033[1mDNS.$num:\033[0m "
			read dns
			
			echo -e "DNS.$num = $dns" >> client.ext
			echo -e "\033[1mDNS.$num\033[0m = $dns\n"
			
			count=$[$count - 1]
		done
		
		answ="d"
	fi
	
	if [ $answ = "d" ]
	then
		sleep 1
		echo -e "ПРЕДУПРЕЖДЕНИЕ: Если Вы создали неправильно предыдущие конфиг. файлы, в дальнейшем будут ошибки!!!\n"
		sleep 1
		cd /certs/extensions/
	else
		sleep 1
		echo -ne "\nОшибка выполнения, начните сначала.\n"
		sleep 1
	fi
	
	echo -ne "\nХотите вернуться в начало? \033[1m(y/n):\033[0m "
	read mark		
	
	if [ $mark = "n" ]
	then
		$locate/test2.sh
		break
	fi
done
