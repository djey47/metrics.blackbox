@ECHO OFF
REM Starts Metrics Controller for Windows
REM TODO Should check for prerequisites (ruby)
ruby ..\rupees\controller.rb -c ..\conf\metrics.win.yaml
PAUSE
