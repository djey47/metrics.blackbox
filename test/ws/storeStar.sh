#! /bin/sh

#Test muti store feature (default port)
echo *Good request...
curl -X POST -H "Content-Type: application/json" -d @data/dataCollection.json http://localhost:4567/collector/APP_TEST
echo
echo *Not a JSON request...
curl -X POST -H "Content-Type: application/json" -d @data/dataCollection_invalid.json http://localhost:4567/collector/APP_TEST
echo
echo *JSON but bad request...
curl -X POST -H "Content-Type: application/json" -d @data/dataCollection_invalid_2.json http://localhost:4567/collector/APP_TEST
echo
echo Done!