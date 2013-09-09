#! /bin/sh
#Starts Metrics Controller for Linux
if hash ruby 2>/dev/null; then
	ruby --version
	#ruby ../rupees/controller.rb -h
	#TODO check for required version + packages
	ruby ../rupees/controller.rb -c ../conf/metrics.nux.yml
else
    echo ruby script engine not found ! Please check your install.
fi
