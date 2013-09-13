#! /bin/sh

#Test multi retrieve feature
echo *Case 1: existing values on previous store.sh/storeStar.sh requests
curl -X GET -d "" http://localhost:4568/server/APP_TEST
echo
echo *Case 2: non-existing values
curl -X GET -d "" http://localhost:4568/server/FOO
echo