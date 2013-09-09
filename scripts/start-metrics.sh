#! /bin/sh

#Starts Metrics Controller for Linux

if hash ruby 2>/dev/null; then
	echo ruby script engine found!
	ruby --version
#TODO check for required version + packages
	ruby ../rupees/controller.rb -c ../conf/metrics.nux.yml
else
    echo ruby script engine not found ! Please check your install.
fi
