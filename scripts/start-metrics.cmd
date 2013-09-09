@ECHO OFF

REM Starts Metrics Controller for Windows

WHERE /Q ruby
IF ERRORLEVEL 0 (
	ECHO ruby script engine found! 
	ruby --version
REM TODO check for required version + packages	
	ruby ..\rupees\controller.rb -c ..\conf\metrics.win.yml
) ELSE (
	ECHO ruby script engine not found ! Please check your install.
) 

PAUSE
