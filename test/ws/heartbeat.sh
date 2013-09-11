#! /bin/sh

#Test running servers (default port)
echo *IN...
curl -X GET -d "" http://localhost:4567/
echo
echo *OUT...
curl -X GET -d "" http://localhost:4568/