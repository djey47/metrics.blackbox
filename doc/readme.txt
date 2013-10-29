-BLACK BOX-
Started on 9th August, 2013
By Djey
------------------------------

* Launch Metrics Controller : run rupees/controller/controller.rb <options>
Use --help switch for <options> details.

 OR via script : 
 $ cd scripts 
 $ start-metrics.cmd (win) / ./start-metrics.sh (linux)
 
 
* CONTROLLER Access : localhost:4560
	-[heartbeat]	/ 
	-[shutdown]		/controller/shutdown 
	-[startFileOut]	/controller/fileOutConnector/start/<appId> 
	-[stopFileOut]	/controller/fileOutConnector/stop 
 
* WS IN Connector : localhost:4567
	-[heartbeat]	/
	-[store]		/collector/<appId>/<ctxId>/<natureId>/<value>
	-[store*] 		/collector/<appId>

* WS OUT Connector : localhost:4568
	-[heartbeat]	/ 
	-[retrieve]		/server/<appId>/<ctxId>/<natureId>
	-[retrieve*]	/server/<appId>


-- TESTING --
* TODO
