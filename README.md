SSL Cipher Tests
================

Tools to check servers for SSL ciphers configured.

##Testing General SSL Servers

This script will work for HTTPS or any type of server that speaks SSL or TLS. 

````
./cipher_test.sh <server> <port> 
````

##Testing SMTP Servers using SSL

To test a SMTP server that is configured to use the STARTTLS command in order to switch from a plain connection to an encrypted one, use the following command:

````
./smtp_cipher_test.pl <server> <port> [SSLv2|SSLv3|TLSv1] [cipher]
````

The last two optional arguments in the command above allow only a single SSL protocol or cipher to be tested.

###Examples

Testing all protocols and ciphers:

    ./smtp_cipher_test.pl smtp.somehost.com 25

Testing a particular SSL protocol only :

    ./smtp_cipher_test.pl smtp.somehost.com 25 TLSv1

Testing a particular SSL protocol and cipher only:

    ./smtp_cipher_test.pl smtp.somehost.com 25 TLSv1 DHE-RSA-AES256-SHA

##Caveat

This tools will only test for ciphers that your system's openssl has been built to use.