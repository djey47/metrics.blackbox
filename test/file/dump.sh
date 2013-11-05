#! /bin/sh

#Test dump feature  WS IN (default port) -> FILE OUT
echo *Starting dump...
curl -X GET http://localhost:4560/controller/fileOutConnector/start/APP_TEST
echo
echo *Go...
curl -X POST -H "Content-Type: application/json" -d @data/dataCollection.json http://localhost:4567/collector/APP_TEST
echo
echo *Stopping dump...
curl -X GET http://localhost:4560/controller/fileOutConnector/stop
echo
echo Done!