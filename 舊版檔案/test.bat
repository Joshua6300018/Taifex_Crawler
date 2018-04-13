@ECHO ON

SET V_BATPATH=%~DP0

ECHO %V_BATPATH%
ECHO %V_BATPATH%123123 

set /p AA=<log.txt

::if not exist log.txt goto first

if %AA% == success_yesToday (
	ECHO Completed~~
	)
::goto end
	
	
if %AA% == success_noToday ECHO noToday 

if %AA% == error (
	ECHO Have conflict data! 
	)
	

:first
for /f %%i in ('C:\Users\90813\Documents\R\R-3.4.3\bin\Rscript %BatchPATH%merge.r MXF 3') do set AA=%%i

::%D:~-1% > %AA%

::SET %D:~-1% > %A%

::ECHO %DD%

REM :: {1=外資,2=自營商,3=投信}
REM ECHO 外資大台(1/6)...
REM %BatchPATH%OI_Data.vbs TXF 1

REM ECHO 自營大台(2/6)...
REM %BatchPATH%OI_Data.vbs TXF 2

REM ECHO 投信大台(3/6)...
REM %BatchPATH%OI_Data.vbs TXF 3

REM ECHO 外資小台(4/6)...
REM %BatchPATH%OI_Data.vbs MXF 1

REM ECHO 自營小台(5/6)...
REM %BatchPATH%OI_Data.vbs MXF 2

REM ECHO 投信小台(6/6)...
REM %BatchPATH%OI_Data.vbs MXF 3 

ECHO %AA% > log\MXF_3.txt

if %AA% == success_yesToday	ECHO Completed~~
if %AA% == success_noToday ECHO noToday 
if %AA% == error ECHO Have conflict data!

::^%AA% > %V_BATPATH%log.txt

:end

pause

