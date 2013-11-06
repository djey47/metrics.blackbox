#! /bin/sh

#Test dump feature  WS IN (default port) -> FILE OUT
echo *Flushing redis...
/home/avsp/applications/redis-2.6.14/src/redis-cli "FLUSHDB"
echo
echo *Starting dump...
curl -X GET http://localhost:4560/controller/fileOutConnector/start/APP_TEST
echo
echo *Go...
for i in `seq 1 100`
do
	curl -X POST -d "" http://localhost:4567/collector/APP_TEST/CTX1/NAT1/$i
	sleep 0
done
echo
echo *Stopping dump...
curl -X GET http://localhost:4560/controller/fileOutConnector/stop
echo
echo Done!