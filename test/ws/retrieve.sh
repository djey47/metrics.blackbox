#! /bin/sh

#Test basic retrieve feature (default port)
echo *Case 1: existing values on previous store.sh test 
curl -X GET -d "" http://localhost:4568/server/APP_TEST/CTX1/NAT1
echo 
curl -X GET -d "" http://localhost:4568/server/APP_TEST/CTX1/NAT2
echo
curl -X GET -d "" http://localhost:4568/server/APP_TEST/CTX2/NAT1
echo
echo *Case 2: nonexisting value
curl -X GET -d "" http://localhost:4568/server/FOO/FOO/FOO
echo	