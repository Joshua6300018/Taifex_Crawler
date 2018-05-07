
@ECHO OFF

ECHO Start

::取得批次檔所在的路徑
SET BatchPATH=%~DP0
SET CompilerPath="C:\Program Files\R\R-3.4.4\bin\Rscript"
::SET CompilerPath="C:\Program Files\R\R-3.4.3\bin\Rscript"

ECHO #######  載入當天資料 #######

::完整契約資訊(依到期月分開)
ECHO 大小台(總OI)
%CompilerPath% %BatchPATH%MTX_Crawler.r TX %BatchPATH%
%CompilerPath% %BatchPATH%MTX_Crawler.r MTX %BatchPATH%
::%CompilerPath% %BatchPATH%MTX_Crawler.r MTX %BatchPATH% all

:: 三大法人
ECHO 大小台(三大法人)...
%CompilerPath% %BatchPATH%Big3_Crawler.r TXF %BatchPATH%
%CompilerPath% %BatchPATH%Big3_Crawler.r MXF %BatchPATH% 

ECHO #######  合併歷史資料與新資料 #######

::合併三大法人...
for /f %%i in ('%CompilerPath% %BatchPATH%mergeBig3.r %BatchPATH%') do set Big3=%%i
if %Big3% == success_yesToday(Big3) ECHO ^  Merge Big3 Completed @@@~~~
if %Big3% == success_noToday(Big3) ECHO ^  No today @@@~~~

::合併全部新舊資料
for /f %%i in ('%CompilerPath% %BatchPATH%mergeAll.r %BatchPATH%') do set All=%%i
if %All% == success_yesToday(All) ECHO ^  Merge All Completed @@@~~~
if %All% == success_noToday(All) ECHO ^  No today @@@~~~

ECHO #######  檢查資料是否正確 + 輸出log #######

REM ::設定當天日期
SET DT=%DATE% %TIME% 

ECHO %DT%  %Big3% >> log\log.txt
ECHO %DT%  %All% >> log\log.txt



	
ECHO Finish

::pause



