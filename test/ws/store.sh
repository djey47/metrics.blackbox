#! /bin/sh

#Test basic store feature (default port)
echo *Case 1...
curl -X POST -d "" http://localhost:4567/collector/APP_TEST/CTX1/NAT1/45.00
echo 
echo *Case 2...
curl -X POST -d "" http://localhost:4567/collector/APP_TEST/CTX1/NAT2/AZERTY
echo 
echo *Case 3...
curl -X POST -d "" http://localhost:4567/collector/APP_TEST/CTX2/NAT1/55.55
echo
echo Done!