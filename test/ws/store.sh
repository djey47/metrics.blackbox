#! /bin/sh

#Test basic store feature (default port)
curl -X POST -d "" http://localhost:4567/collector/APP_TEST/CTX1/NAT1/45.00
curl -X POST -d "" http://localhost:4567/collector/APP_TEST/CTX1/NAT2/AZERTY
curl -X POST -d "" http://localhost:4567/collector/APP_TEST/CTX2/NAT1/55.55