# Полный гайд по созданию, настройке и использованию сертификатов

*Перед созданием сертификатов рекомендуется изучить тему о сертификата, 
в противном случае, при незнании теории будет бессмысленно проходить практику (не будет погружения в понимание процессов).*

# ТЕОРИЯ
-------------
Актуальность
---------------------------

Когда тот или иной пользователь пользуется Интернетом, переходя от одного веб-сайта к другому, его устройство (ПК, ноутбук, телефон и т. д.) на протяжении всего времени, устанавливает сеансы связи с различными доменами и общается с ними по принципу взаимодействия - "Клиент - Сервер".

Само общение реализуется путём отправления сообщений между ними, сами сообщения в открытой среде никак не защищаются, что может привести к утечке конфиденциальных данных, полной модификацией злоумышленником этих конфиденциальных данных и отправления их на серсер, и (или) полного перехвата данных.

Как следствие, пользование интернетом небезопасно, что приводит к невозможности от общения с кем-либо без постороннего вмешательства, до проведения транзакций через интернет. Поэтому для обеспечения безопасности в этом периметре, используются сертификаты безопасности.


Определение и объяснение
-------------------------

Основной способ защиты сообщений от чтения - **шифрование**; сообщения шифруют, используя методы симметричного или ассмиетричного шифрования.


**Симметричное шифрование** - вид шифрования, где используются закрытые ключи и у отправитиля, и у получателя, с помощью которых и происходит расшифровка сообщений.

**Ассиметричное шифрование** - вид шифрования, где используются открытый и закрытый ключ, открытый ключ, который шифрует сообщение и который свободно отправляется через незащищённую сеть, и закрытый ключ, который используется для расшифровки сообщения и который хранится на сервере.

Для безопасного соединения, используются криптографические протоколы - **Secure Sockets Layer (SSL) и Transport Layer Security (TSL).**

**Secure Socket Layer** - это криптографический протокол, обеспечивающий безопасное общение пользователя и сервера по небезопасной сети. Располагается между транспортным и прикладным уровнем, с 2015 года стал полностью устаревшим.

**Transport Layer Security** - это более актуальная версия протокола SSL; особенность этого протокола в том, что он использует гибридное шифрование, то есть, совместного использования ассиметричного и симметричного шифрования.

Технология сертификатов безопасности использует асситеричное шифрование в HTTPS протоколе, закрытый ключ хранится на сервере, а открытый ключ в виде сертификата передаётся пользователю, который в этом нуждается.

**Cертификат** - это не только открытый ключ, это и ещё информация о владельце сертификата (кто его выпустил и кому оно назначено), таким образом определяется достоверность сертификата, даже если его кто-то попытается подделать, потому что сертификаты имеют подпись, которую подделать нельзя, сертификат подписывается доверенным центром сертификации (CA); информация о том, кто подписал и кому назначен сертифика, указана в самом сертификате.
Если сертификат не подписывать, устройство не будет ему доверять.

При создании подписи,происходит процесс шифровки хэша подписи с помощью закрытого ключа (не путать с шифрованием передачи данных), а процесс его расшифровки проходит с участием открытого ключа, факт того, что подпись была сделана именно владельцем закрытого ключа, определяется по тому, соответствует ли хэш подписи с хэшом данных.


**Виды сертификатов**
----------------------

- **Корневой сертификат (CA)** - это сертификат, который находится в основании дерева сертификатов, он подписывается сторонним центром сертификации (CA), либо самоподписывается.

- **Серверный сертификат** - это сертификат, который подписывается корневым сертификатом и устанавливается на сервере.

- **Клиентский (промежуточный) сертификат** - это сертификат, который подписывается корневым сертификатом и обеспечивает звено доверия между различными сертификатами, таким образом, что разные производители могут выдавать промежуточные сертификаты, а корневой сертификат у всех может быть один.


Принцип работы
---------------

1. Когда устройство отправляет запрос на создание сеанса связи на сервер, в самом сообщении содержится информация о предпочитаемой версии протокола TLS, набора поддерживаемых шифров (Cipher Spec), и случайного простого числа (client random), необходимого в дальнейшем для генерации общего ключа симметричного шифрования.
 
2. Сервер отвечает выбранной версией протокола из предложенного набора шифром, которые будут непосредственно использоваться, своим случайным простым числом и идентификатором сессии (нужно для возобновления соединения, для экономии времени).

3. Как уже было упомянуто, сертификаты надо подписывать, сервер отправляет свой сертификат, а клиент проводит проверку подписи удостоверяющего центра, проверку доверия, проверку домена, срок действия и был ли сертификат отозван.

4. Далее, сервер отправляет общий ключ клиенту, зашифрованный открытым ключом, либо используется более надёжный алгоритм - алгоритм Диффи Хеллмана (server key exchange).

5. После чего, сервер сообщает, что начальный этап установки соединения завершён.

6. В случае использования алгоритма Диффи Хеллмана, случайное число клиента, сервера и предварительный разделяемый ключ - выдают симметричный ключ и ключ вычисления хэша данных.
Симметричный ключ и ключ вычисления хэша данных позволяют начать работу при безопасной передаче данных.

7. Далее, клиент сообщает серверу о готовности перейти на защищённое соединение, после чего, зашифровывает сообщение симметричным ключом с хэшом данных.

8. Сервер проверяет полученное сообщение, далее отвечает тем, что готов перейти к защищённому соединению, после чего, аналогично клиенту, отправляет зашифрованное сообщение с хэшом данных.

9. После всех этих манипуляций, обеспечивается безопасная передача данных.

10. Последний этап - завершение общения; одна сторона сообщает о том, что считает соединение разорванным и не будет больше принимать сообщения, вторая сторона обязана ответить тем же сообщением.
#
------------

# ПРАКТИКА

- Для начала работы необходимо установить пакет **"openssl"**.

- Для **Linux** нужно ввести apt (yum) install openssl - зависит от дистрибутива.

- Для **Windows** можно скачать по ссылке - https://slproweb.com/products/Win32OpenSSL.html

- После этого, необходимо настроить **PATH**, для того, чтобы команды работали в терминале.

- После успешной установки пакета, нужно изучить структуру команд.

## **Структура команды OpenSSL**

```
openssl "команда" "опции"
```

## Перечень команд **OpenSSL**

- **openssl** - основная команда инициализации программной среды OpenSSL;

- **genpkey** (заменяет **genrsa, gendh, gendsa**) - генерирует приватные ключи;

- **req** - утилита для создания запросов на подпись сертификата и для создания самоподписанных сертификатов **PKCS#10**;

- **x509** - утилита для подписи сертификатов и для показа свойств сертификатов;

- **rsa** - утилита для работы с ключами **RSA**, например, для конвертации ключей в различные формы;

- **enc** - различные действия с симметричными шифрами;

- **pkcs12** - создаёт и парсит файлы **PKCS#12**;

- **crl2pkcs7** - программа для конвертирования **CRL** в **PKCS#7**;

- **pkcs7** - выполняет операции с файлами **PKCS#7** в **DER** или **PEM** формате;

- **verify** - программа для проверки цепей сертификатов;

- **s_client** - команда реализует клиент SSL/TLS, который подключается к удалённому хосту с использованием SSL/TLS. Это очень полезный инструмент диагностики для серверов SSL;

- **ca** - является минимальным CA-приложением. Она может использоваться для подписи запросов на сертификаты в различных формах и генерировать списки отзыва сертификатов. Она также поддерживает текстовую базу данных выданных сертификатов и их статус.

- **rand** - эта команда генерирует указанное число случайных байт, используя криптографически безопасный генератор псевдослучайных чисел **(CSPRNG)**;

- **rsautl** - команда может быть использована для подписи, проверки, шифрования и дешифрования данных с использованием алгоритма **RSA**;

- **smime** - команда обрабатывает S/MIME почту. Она может шифровать, расшифровать, подписывать и проверять сообщения S/MIME.
```
Чтобы посмотреть весь список команд, используйте - "openssl list -commands";
```

## **Подготовка к созданию SSL-сертификатов**

### **ПРИМЕЧАНИЕ**
Будут использоваться сертификаты X.509 v3, так как в них используются расширения для того, чтобы задать свойства сертификатам.

**Создаём файл - ext.conf**:

``
touch ext.conf
``

**Задаём ему следующие свойства**

### **[ req ]**

КОМАНДА | ОПИСАНИЕ
------------- | ---------------
**default_bits			= 3072** | длина шифрования по умолчанию (в бит.)
**default_keyfile			= prot_one.key** | название приватного ключа по умолчанию
**distinguished_name		= req_distinguished_name** | название интерактивного файла, отвечающего за запись общих данных о создателе сертификата
**attributes			= req_attributes** | название интеркативного файла, отвечающего за правило записи паролей
**x509_extensions			= v3_ca** | название файла, отвечающего за использование расширений
**string_mask			= utf8only** | использование кодировки


### **[ req_distinguished_name ]**
---------------------------
КОМАНДА | ОПИСАНИЕ
------------- | ---------------
**countryName			= Country Name (2 letter code)** | название страны (запрос)
**countryName_default		= RU**	| название страны по умолчанию
**countryName_min			= 2**	| минимальное кол-во символов
**countryName_max			= 2** | максимальное кол-во символов
**stateOrProvinceName		= Some state or province** | название области (запрос)
**stateOrProvinceName_default	= Moscow**	| название области по умолчанию
**localityName			= Locality Name (eg, city)** | название города (запрос)
**localityName_default		= Moscow** | название города по умолчанию
**organizationName		= Organization Name (eg, org)** | название организации (запрос)
**organizationName_default	= WorldSkills** | название организации по умолчанию
**organizationalUnitName		= Organizational Unit Name (eg, section)** | название отдела организации (запрос)
**organizationalUnitName_default	= IT** | название отдела организации по умолчанию
**commonName			= Common Name (eg, YOUR name)** | основное DNS-имя или IP-адрес
**commonName_default		= CA** | имя по умолчанию
**commonName_max			= 64** | максимальная длина имени
**emailAddress			= Email Address** | имя электронной почты (запрос)
**emailAddress_default		= ca-support@demo.lab** | имя электронной почты по умолчанию
**emailAddress_max		= 40** | максисальная длина имени электронной почты

### **[ req_attributes ]**
------------------------
КОМАНДА | ОПИСАНИЕ
------------- | ---------------
**challengePassword		= A challenge Password** | ввод пароля (запрос)
**challengePassword_min		= 4** | минимальная длина пароля
**challengePassword_max		= 20** | максимальная длина пароля
**unstructuredName		= An optionaly company name** | использование имени компании опционально (запрос)

### **[ v3_ca ]**
-------------
КОМАНДА | ОПИСАНИЕ
------------- | ---------------
**authorityKeyIdentifier		= keyid,issuer** | указываем использование данных о расширении ключа для его идентификации
**basicConstraints		= CA:FALSE** | указываем, что является ли этот сертификат - сертификатом CA (True) или это сертификат для конечного объекта (False). Также параметр может быть критическим (critical, CA:TRUE). Также может быть необязательный атрибут, определяющий максимальную глубину цепочки сертификатов - pathLen (CA:TRUE, pathLen:INTEGER).
**keyUsage			= digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment, keyCertSign** | указываем основные права сертификата
**subjectKeyIdentifier		= hash** | указываем идентификатор ключа субъекта 
**subjectAltName			= @alt_names** | указываем альтернативные DNS-имена для использования сертификатом.

### **[ alt_names ]**

КОМАНДА | ОПИСАНИЕ
------------- | ---------------
**DNS.1				= CA** | DNS1
**DNS.2    = CA.demo.lab** | DNS2

### Сохраняем файл конфигурации

## Создаём файл - **client.ext**, который будет содержать расширения для промежуточного сертификата, в файле будут следующие свойства:

- **authorityKeyIdentifier		= keyid,issuer**

- **basicConstraints		= CA:TRUE,pathlen:2**

- **keyUsage			= digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment, keyCertSign**

- **subjectKeyIdentifier		= hash**

- **subjectAltName			= @alt_names**

### **[ alt_names ]**

- **DNS.1				= Intermediate**

- **DNS.2				= Intermediate.demo.lab**

### Заполняем его, указывая только расширения
-------------------------------------------------------------------------------------------------------------------------------------------------------------

## Создаём файл - **server.ext**. который будет содержать расширения для серверного сертификата, в файле будут следующие свойства:
-------------------------------------------------------------------------------------------------------------------------------------------------------------
**authorityInfoAccess		= OCSP;URI:http://ocsp.my.host/** | онлайн версия списка отзывов, указывается, чтобы свести к минимуму вероятность приёма уже отозванного сертификат
------------- | ---------------

- **authorityKeyIdentifier		= keyid,issuer**

- **basicConstraints		= critical, CA:FALSE**

- **keyUsage			= digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment**

- **subjectKeyIdentifier		= hash**

- **subjectAltName			= @alt_names**

### **[ alt_names ]**

- **DNS.1**				= www

- **DNS.2**				= www.demo.lab

- **DNS.3**				= www.demo.ru

- **DNS.4**				= www.demo.com

### **ВАЖНО** - когда будете указывать **commonName**, пишите DNS-имя или IP-адрес веб-сервера к которому подключаетесь.

Свойства параметра - **keyUsage**:
--------------------------------------------------------------------------------------------------------------------
- **digitalSignature** - наличие цифровой подписи

- **nonRepudiation** - наличие свойства неотказуемости, то есть, доказательство происхождения данных и их целостность

- **keyEncipherment** - обозначает, что ключ в сертификате используется для шифрования другого криптографического ключа

- **dataEncipherment** - обозначает, что ключ субъекта сертификата используется для прямого шифрования необработанных пользовательских данных.

- **keyCertSign** - обозначает, что сертификат может использоваться для подписи других сертификатов

- **cRLSign** - используется для проверки подписей в списках отзывов сертификатов (CRL)

- **decipherOnly** - устанавливает, что открытый ключ используется только для расшифрования данных

- **encipherOnly** - устанавливает, что открытый ключ используется только для зашифрования данных

- **keyAgreement** - устанавливается для управления зашифрованными ключами.

### Все указанные свойства устанавливаются избирательно и при необходимости

#
----------------------------------
## **Создание SSL-сертификатов**
### 1. Для начала, создаём корневой сертификат, а к нему уже, будем крепить остальные, но для этого, сначала нужно создать приватный ключ для корневого сертификата

``
openssl genrsa -out rootCAKey.key 2048 - закрытый ключ от корневого сертификата
``

- **openssl** - инициализатор программного решения - OpenSSL;

- **genrsa** - команда для генерации закрытых ключей; 

- **-out <имя файла>** - вывод результата в определённый файл; 

- **формат .key** - предназначен для закрытых ключей; 

- **2048** - длина шифрования (в бит).

### 2. После генерации закрытого ключа, создаём и подписываем корневой сертификат его же закрытым ключом (делаем самоподписанный сертификат).

``
openssl req -x509 -new -key rootCAKey.key -sha256 -days 365 -config ext.conf -out rootCACert.crt
``

- **req** - команда, которую в нашем случае, мы используем для генерации самоподписанных сертификатов по формату **PKCS#10**

- **-x509** - стандарт, который используется для подписи сертификатов. (**ВАЖНО** - не путать **req -x509** и **x509 -req** - первое - генерирует запрос на подпись сертификата или сам самоподписанный сертификат, второе - используется для подписи сертификатов уже готовым корневым сертификатом и его приватным ключом).

- **-new** - флаг для создания нового запроса

- **-key <имя ключа>** - флаг для использования существующего ключа

- **-sha256** - использование определённой кодировки шифрования

- **-config <имя файла>** - использование конфигурационного файла для формирования правила генерации сертификата *(по умолчанию - используется уже существующий конфигурационный файл - **openssl.cnf**, расположенный в /usr/lib/ssl/)*

#### *Далее, будет ряд запросов - (Страна, область, город и т.д.), заполняете в соответствии с требованиями.*

### 3. После генерации корневого сертификата, создаём ещё 2 приватных ключа: первый - для промежуточного сертификата, второй - для серверного сертификата, по аналогии с генерацией ключа для корневого сертификата.

``
openssl genrsa -out clientCAKey.key 2048 - закрытый ключ от промежуточного сертификата
``

``
openssl genrsa -out serverCAKey.key 2048 - закрытый ключ от серверного сертификата
``

### 4. Теперь генерируем запрос на подпись промежуточного и серверного сертификата.

``
openssl req -new -newkey rsa:2048 -sha256 -nodes -key clientKey.key -out clientReq.csr
``

``
openssl req -new -newkey rsa:2048 -sha256 -nodes -key serverKey.key -out serverReq.csr
``

- **-newkey** - использование секретного ключа, который записывается в существующий ключ **(key)** или новый ключ **(keyout)**.

- **-nodes** - подавляет диалог запроса парольной фразы. 

#### **ВАЖНО**

При вводе данных во время создания серверного запроса - внимательно вводите данные в графе - commonName; там нужно указать DNS-имя сервера или его IP-адрес.

### 5. После генерации запросов на подпись, подписываем промежуточный сертификат - корневым сертификатом и его закрытым ключом, а серверный сертификат - промежуточным сертификатом и его закрытым ключом.

``
openssl x509 -req -in clientReq.csr -CA rootCACert.crt -CAkey rootCAKey.key -CAcreateserial -out clientCert.crt -days 365 -sha256 -extfile client.ext
``

``
openssl x509 -req -in serverReq.csr -CA clientCert.crt -CAkey clientKey.key -CAcreateserial -out serverCert.crt -days 365 -sha256 -extfile server.ext
``

- **-in <имя файла>** - используем запрос на подпись, чтобы его подписать

- **-CA <имя файла>** - используем корневой сертификат, которым будем подписывать клиентский и серверный запросы.

- **-CAKey <имя файла>** - аналогично предыдущей команде, используются закрытый ключ корневого сертификата.

- **-CAcreateserial** - создаём файл, который будет создавать серийные номера для подписи сертификатов.

- **-extfile** - используем данные с файла, в котором будут храниться расширения для запросов.

### 6. После генерации всех сертификатов, - **clientCert.crt и rootCACert.crt**, переносим их на другую машину,

``
В нашем случае, мы перенесли сертификаты на машину с ОС Windows, далее, будем работать с ней
``

#### Следующим этапом, открываем окно "Выполнить"
``
Win + R
``

#### После чего вводим туда
``
certmgr.mscr
``

#### Где открывается окно менеджера управления сертификатами

[<img src="https://github.com/fengter/Certifications/blob/main/photo1.png">](https://github.com/fengter/Certifications/blob/main/photo1.png)

#### Далее, открываем каталог - "Доверенные корневые центры сертификации" после, нажимаем ПКМ по каталогу "Сертификаты" -> "Все задачи" -> "Импорт"

[<img src="https://github.com/fengter/Certifications/blob/main/photo2.png">](https://github.com/fengter/Certifications/blob/main/photo2.png)

#### Где открывается "Мастер импорта сертификатов", далее следуем инструкциям.

### ВАЖНО

``
На этапе указания сертификата, в качестве доверенного корневого центра сертификации, нужно указывать только rootCACert.crt
``

``
Чтобы добавить промежуточный сертификат, найдите каталог - "Промежуточные центры сертификации", после чего, выполните ранее указанные шаги.
``

### 7. Далее, будем настраивать работу веб-сервера, поэтому возвращаемся в машину веб-сервера

- В нашем случае, используется сервер **Nginx**, поэтому заходим в файл iwtm.conf, расположенный в /etc/nginx/conf.d/

``
vi /etc/nginx/conf.d/iwtm.conf
``

- Далее находим 2 ключа - **ssl_certificate** и **ssl_certificate_key**

- После чего, меняем их значения на соответствующие текущие пути серверного сертификата и его ключа

### 8. Далее проверяем, что сервер - nginx работает:

``
nginx -t
``

### 9. Если всё работает, то перезапускаем его.

``
service nginx restart
``

### 10. Наконец, заходим с машины, на которую мы установили сертификаты и в браузере переходим по ранее указаному нами DNS-имени. 
-------------------------------------------------------------------------------------------
