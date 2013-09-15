#! /bin/sh

#Test basic store feature (default port)
echo *Case 1: valid requests...
curl -X POST -d "" http://localhost:4567/collector/APP_TEST/CTX1/NAT1/45.00
curl -X POST -d "" http://localhost:4567/collector/APP_TEST/CTX1/NAT2/AZERTY
curl -X POST -d "" http://localhost:4567/collector/APP_TEST/CTX2/NAT1/55.55
echo 
echo *Case 2: valid request, other APP_ID...
curl -X POST -d "" http://localhost:4567/collector/APP_TEST_2/CTX1/NAT2/UIOPQS
echo
echo Done!