#!/bin/bash
#tests a server/port for which ssl ciphers are supported

CIPHERS=`openssl ciphers | sed -e 's/:/ /g'`
PROTOCOLS="ssl2 ssl3 tls1"
TIMEOUT=10
DEBUG=0

#to work on mac osx you will need to add the following bash function:
SYSTEM_TIMEOUT=`which timeout`
if [[ "${SYSTEM_TIMEOUT}" -eq "" ]]; then
	function timeout() { perl -e 'alarm shift; exec @ARGV' "$@"; }
fi

SERVER=$1
PORT=$2
echo "Testing: ${SERVER}:${PORT}"

for PROTOCOL in ${PROTOCOLS}; do
	for CIPHER in ${CIPHERS}; do
		echo -n "Connecting using: ${PROTOCOL} ${CIPHER}... "
		RESULT=`echo -n | timeout $TIMEOUT openssl s_client -cipher "$CIPHER" -connect ${SERVER}:${PORT} -${PROTOCOL} 2>&1`
		if [[ "${RESULT}" =~ "Cipher is ${CIPHER}" ]]; then
			echo "OK"
		else
			echo "ERR"
			if [[ ${DEBUG} > 0 ]]; then
				echo ${RESULT} | grep "error" || echo "Unknown error"
			fi
		fi
	done
done
echo "...done"
