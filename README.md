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
./smtp_cipher_test.pl <server> <port> 
````

##Caveat
This tools will only test for ciphers that your system's openssl has been built to use.