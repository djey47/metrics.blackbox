#! /bin/sh

#Shutdowns Metrics Controller for Linux
echo *Shutting metrics down ...
curl -X GET -d "" http://localhost:4560/controller/shutdown
echo
echo Done!