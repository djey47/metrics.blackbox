#! /bin/sh

#Test running servers (default ports)
echo *CONTROLLER ACCESS...
curl -X GET -d "" http://localhost:4560/
echo 
echo *IN...
curl -X GET -d "" http://localhost:4567/
echo
echo *OUT...
curl -X GET -d "" http://localhost:4568/
echo