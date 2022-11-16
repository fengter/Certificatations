#!/bin/bash
answ0="y"

while [ $answ0 = "y" ]
do
	sleep 1
	echo -en "\n\n\033[1mВыберите этап генерации сертификатов:\033[0m \n\033[1m----------------------------------------------------------------------------------\n\033[0m\033[1m(a):\033[0m Генерация закрытого ключа для корневого сертификата \033[1m(НАЧАЛО)\033[0m;\n\n\033[1m(b):\033[0m Создание и подпись корневого сертификата;\n\n\033[1m(c):\033[0m Генерация закрытого ключа для промежуточного сертификата;\n\n\033[1m(d):\033[0m Создание запроса на подпись промежуточного сертификата;\n\n\033[1m(e):\033[0m Подпись промежуточного сертификата;\n\n\033[1m(f):\033[0m Создание закрытого ключа для серверного сертификата;\n\n\033[1m(g):\033[0m Создание запроса на подпись серверного сертификата;\n\n\033[1m(h):\033[0m Подпись серверного сертификата;\n\n\033[1m(i):\033[0m Создание инструкции для старта работы сертификатов;\n\n\033[1m(j):\033[0m Упаковка сертификатов в пакет - pkcs#12.\n\033[1m----------------------------------------------------------------------------------\033[0m\n\n\n\033[1mВаш ответ: \033[0m"
	read answ1
	
	if [ $answ1 = "a" ]
	then
		if [ -d "/certs/extensions/" ]
		then
			sleep 1
			echo " "
		else
			sleep 1
			echo -e "\033[1m\nПРЕДУПРЕЖДЕНИЕ:\033[0m Отсутствие необходимых конфигурационных файлов может привести к ошибке работы!!!\n"
			
			mkdir -p /certs/crts/ /certs/keys/ /certs/extensions/ /certs/csrs/
		fi

		cd /certs/

		sleep 1
		echo -e "Создание закрытого ключа для корневого сертификата ..."
		
		sleep 1
		echo -ne "\nУкажите имя ключа \033[1m(e.g. name.key):\033[0m "
		read nameK1
		
		sleep 1
		echo -ne "\nУкажите длину шифрования ключа \033[1m(e.g. 1024):\033[0m "
		read length
		
		sleep 1
		echo -e "\nКлюч генерируется ..."
		sleep 1

		openssl genrsa -out keys/$nameK1 $length
	
		answ1="b"
	fi
	
	if [ $answ1 = "b" ]
	then
		if [ -d "/certs/extensions/" ]
		then
			sleep 1
			echo " "
		else
			sleep 1
			echo -e "\033[1m\nПРЕДУПРЕЖДЕНИЕ:\033[0m Отсутствие необходимых конфигурационных файлов может привести к ошибке работы!!!\n"
			
			mkdir -p /certs/crts/ /certs/keys/ /certs/extensions/ /certs/csrs/
		fi

		cd /certs/
		
		echo -e "\nСоздание и подписывание корневого сертификата ..."
		
		sleep 1
		echo -ne "\nУкажите имя сертификата \033[1m(e.g. rootCert.crt):\033[0m "
		read nameCT1
		
		sleep 1
		echo -ne "\nУкажите кодировку шифрования \033[1m(e.g. sha256):\033[0m "
		read code
		
		sleep 1
		echo -ne "\nУкажите срок действия сертификата \033[1m(в днях) (e.g. 365):\033[0m "
		read days
		
		sleep 1
		openssl req -x509 -new -key keys/$nameK1 -$code -days $days -config extensions/ext.conf -out crts/$nameCT1
		
		answ1="c"
	fi
	
	if [ $answ1 = "c" ]
	then
		if [ -d "/certs/extensions/" ]
		then
			sleep 1
			echo " "
		else
			sleep 1
			echo -e "\033[1m\nПРЕДУПРЕЖДЕНИЕ:\033[0m Отсутствие необходимых конфигурационных файлов может привести к ошибке работы!!!\n"
			
			mkdir -p /certs/crts/ /certs/keys/ /certs/extensions/ /certs/csrs/
		fi

		cd /certs/
		
		sleep 1
		echo -e "\nСоздание закрытого ключа для промежуточного сертификата ... "
		
		sleep 1
		echo -ne "\nУкажите имя ключа \033[1m(e.g. name.key):\033[0m "
		read nameK2
		
		sleep 1
		echo -ne "\nУкажите длину шифрования ключа \033[1m(e.g. 1024):\033[0m "
		read length
		
		sleep 1
		echo -e "\nКлюч генерируется ..."
		
		sleep 1
		openssl genrsa -out keys/$nameK2 $length
		
		
		answ1="d"
	fi
	
	if [ $answ1 = "d" ]
	then
		if [ -d "/certs/extensions/" ]
		then
			sleep 1
			echo " "
		else
			sleep 1
			echo -e "\033[1m\nПРЕДУПРЕЖДЕНИЕ:\033[0m Отсутствие необходимых конфигурационных файлов может привести к ошибке работы!!!\n"
			
			mkdir -p /certs/crts/ /certs/keys/ /certs/extensions/ /certs/csrs/
		fi

		cd /certs/

		sleep 1
		echo -e "\nСоздание запроса на подпись ... "
		
		sleep 1
		echo -ne "\nУкажите имя запроса \033[1m(e.g. name.csr):\033[0m "
		read nameCS1
		
		sleep 1
		echo -ne "\nУкажите кодировку шифрования \033[1m(e.g. sha256):\033[0m "
		read code
		
		sleep 1
		openssl req -new -newkey rsa:$length -$code -nodes -key keys/$nameK2 -out csrs/$nameCS1
		
		sleep 1
		echo -e "\nСоздание запроса на подпись промежуточного сертификата завершён!"
		
		
		answ1="e"
	fi
	
	if [ $answ1 = "e" ]
	then
		if [ -d "/certs/extensions/" ]
		then
			sleep 1
			echo " "
		else
			sleep 1
			echo -e "\033[1m\nПРЕДУПРЕЖДЕНИЕ:\033[0m Отсутствие необходимых конфигурационных файлов может привести к ошибке работы!!!\n"
			
			mkdir -p /certs/crts/ /certs/keys/ /certs/extensions/ /certs/csrs/
		fi

		cd /certs/
		
		sleep 1
		echo -e "\nЗапуск процесса подписи промежуточного сертификата ..."
		
		sleep 1
		echo -ne "\nУкажите имя промежуточного сертификата \033[1m(e.g. name.crt):\033[0m "
		read nameCT2
		
		sleep 1
		echo -ne "\nУкажите срок действия промежуточного сертификата \033[1m(в днях) (e.g. 365):\033[0m "
		read days
		
		sleep 1
		echo -ne "\nУкажите кодировку шифрования \033[1m(e.g. sha256):\033[0m "
		read code
		
		sleep 1
		echo -e "\nНачинается процесс подписи промежуточного сертификата ..."
		
		sleep 1
		openssl x509 -req -in csrs/$nameCS1 -CA crts/$nameCT1 -CAkey keys/$nameK1 -CAcreateserial -out crts/$nameCT2 -days $days -$code -extfile extensions/client.ext
		
		sleep 1
		echo -e "\nПодпись промежуточного сертификата завершена!"
		
		
		answ1="f"
	fi
	
	if [ $answ1 = "f" ]
	then
		if [ -d "/certs/extensions/" ]
		then
			sleep 1
			echo " "
		else
			sleep 1
			echo -e "\033[1m\nПРЕДУПРЕЖДЕНИЕ:\033[0m Отсутствие необходимых конфигурационных файлов может привести к ошибке работы!!!\n"
			
			mkdir -p /certs/crts/ /certs/keys/ /certs/extensions/ /certs/csrs/
		fi

		cd /certs/
		
		sleep 1
		echo -e "\nСоздание закрытого ключа для серверного сертификата ..." 
		
		sleep 1
		echo -ne " \nУкажите имя ключа \033[1m(e.g. name.key):\033[0m "
		read nameK3
		
		sleep 1
		echo -ne "\nУкажите длину шифрования ключа \033[1m(e.g. 1024):\033[0m "
		read length
		
		sleep 1
		echo -e "\nКлюч генерируется ..."

		sleep 1
		openssl genrsa -out keys/$nameK3 $length
		
		
		answ1="g"
	fi
	
	if [ $answ1 = "g" ]
	then
		if [ -d "/certs/extensions/" ]
		then
			sleep 1
			echo " "
		else
			sleep 1
			echo -e "\033[1m\nПРЕДУПРЕЖДЕНИЕ:\033[0m Отсутствие необходимых конфигурационных файлов может привести к ошибке работы!!!\n"
			
			mkdir -p /certs/crts/ /certs/keys/ /certs/extensions/ /certs/csrs/
		fi

		cd /certs/
		
		sleep 1
		echo -e "\nСоздание запроса на подпись ..." 

		sleep 1
		echo -ne "\nУкажите имя запроса \033[1m(e.g. name.csr):\033[0m "
		read nameCS2
		
		sleep 1
		echo -ne "\nУкажите кодировку шифрования \033[1m(e.g. sha256):\033[0m "
		read code
		
		sleep 1
		openssl req -new -newkey rsa:$length -$code -nodes -key keys/$nameK3 -out csrs/$nameCS2
		
		sleep 1
		echo -e "\nСоздание запроса на подпись серверного сертификата завершён!"
		
		
		answ1="h"
	fi
	
	if [ $answ1 = "h" ]
	then
		if [ -d "/certs/extensions/" ]
		then
			sleep 1
			echo " "
		else
			sleep 1
			echo -e "\033[1m\nПРЕДУПРЕЖДЕНИЕ:\033[0m Отсутствие необходимых конфигурационных файлов может привести к ошибке работы!!!\n"
			
			mkdir -p /certs/crts/ /certs/keys/ /certs/extensions/ /certs/csrs/
		fi

		cd /certs/
		
		sleep 1
		echo -e "\nЗапуск процесса подписи серверного сертификата ..." 

		sleep 1
		echo -ne "\nУкажите имя промежуточного сертификата \033[1m(e.g. name.crt):\033[0m "
		read nameCT3
		
		sleep 1
		echo -ne "\nУкажите срок действия серверного сертификата \033[1m(в днях) (e.g. 365):\033[0m "
		read days
		
		sleep 1
		echo -ne "\nУкажите кодировку шифрования \033[1m(e.g. sha256):\033[0m "
		read code
		
		sleep 1
		echo -e "\nНачинается процесс подписи серверного сертификата ..."
		
		sleep 1
		openssl x509 -req -in csrs/$nameCS2 -CA crts/$nameCT2 -CAkey keys/$nameK2 -CAcreateserial -out crts/$nameCT3 -days $days -$code -extfile extensions/server.ext
		
		sleep 1
		echo -e "\nПодпись серверного сертификата завершена!"

		answ1="i"
	fi

	if [ $answ1 = "i" ]
	then
		if [ -d "/certs/extensions/" ]
		then
			sleep 1
			echo " "
		else
			sleep 1
			echo -e "\033[1m\nПРЕДУПРЕЖДЕНИЕ:\033[0m Отсутствие необходимых конфигурационных файлов может привести к ошибке работы!!!\n"
			
			mkdir -p /certs/crts/ /certs/keys/ /certs/extensions/ /certs/csrs/
		fi

		cd /certs/
		
		sleep 1
		echo -e "Инструкция по выполнению задания находится в файле - \033[1m(instruct.txt)\033[0m"

		touch instruct.txt
		
		echo -e "Откройте файл: /etc/nginx/conf.d/iwtm.conf\n\nЗатем найдите 2 ключа - ssl_certificate и ssl_certificate_key\n\nВведите на место указанного пути, указанные ниже данные!" >> instruct.txt
		
		echo -e "\n/certs/crts/$nameCT3\n/certs/keys/$nameK3" >> instruct.txt
		
		
		answ1="j"
	fi
	
	if [ $answ1 = "j" ]
	then
		if [ -d "/certs/extensions/" ]
		then
			sleep 1
			echo " "
		else
			sleep 1
			echo -e "\033[1m\nПРЕДУПРЕЖДЕНИЕ:\033[0m Отсутствие необходимых конфигурационных файлов может привести к ошибке работы!!!\n"
			
			mkdir -p /certs/crts/ /certs/keys/ /certs/extensions/ /certs/csrs/
		fi

		sleep 1
		echo -en "Хотите упаковать сертификаты в формат - pkcs12? \033[1m(y/n):\033[0m "
		read answ
		
		if [ $answ = "y" ]
		then
			cd /certs/

			sleep 1
			echo -e "\nУкажите имя упаковочного пакета \033[1m(e.g. name.p12):\033[0m "
			read namep

			sleep 1
			openssl pkcs12 -export -in crts/$nameCT2 -inkey keys/$nameK2 -certfile crts/$nameCT1 -out $namep
			
			sleep 1
			echo -e "\nУпаковка сертификатов в пакет была успешно завершена!"
		fi
		
		sleep 1
		echo -e "Хотите вернуться в начало? \033[1m(y/n):\033[0m "
		read answ0
	else
		sleep 1
		echo "Повторите попытку!"
	fi
done
