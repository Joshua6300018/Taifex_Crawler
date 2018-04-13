
@ECHO OFF

ECHO Start

::取得批次檔所在的路徑
SET BatchPATH=%~DP0
SET CompilerPath="C:\Users\90813\Documents\R\R-3.4.3\bin\Rscript"
::SET CompilerPath="C:\Program Files\R\R-3.4.3\bin\Rscript"

ECHO #######  載入當天資料 #######

::完整契約資訊(依到期月分開)
ECHO 大小台(總OI)
%CompilerPath% %BatchPATH%MTX_Crawler.r TX %BatchPATH% all
%CompilerPath% %BatchPATH%MTX_Crawler.r MTX %BatchPATH% all

:: 三大法人
ECHO 大小台(三大法人)...
%CompilerPath% %BatchPATH%Big3_Crawler.r TXF %BatchPATH%
%CompilerPath% %BatchPATH%Big3_Crawler.r MXF %BatchPATH% 

ECHO #######  合併歷史資料與新資料 #######

REM ::外資大台(1/6)...
REM for /f %%i in ('%CompilerPath% %BatchPATH%merge.r TXF 1 %BatchPATH%') do set TXF1=%%i
REM if %TXF1% == success_yesToday ECHO Completed(1/6)~~

REM ::自營大台(2/6)...
REM for /f %%i in ('%CompilerPath% %BatchPATH%merge.r TXF 2 %BatchPATH%') do set TXF2=%%i
REM if %TXF2% == success_yesToday ECHO Completed(2/6)~~

REM ::投信大台(3/6)...
REM for /f %%i in ('%CompilerPath% %BatchPATH%merge.r TXF 3 %BatchPATH%') do set TXF3=%%i
REM if %TXF3% == success_yesToday ECHO Completed(3/6)~~

REM ::外資小台(4/6)...
REM for /f %%i in ('%CompilerPath% %BatchPATH%merge.r MXF 1 %BatchPATH%') do set MXF1=%%i
REM if %MXF1% == success_yesToday ECHO Completed(4/6)~~

REM ::自營小台(5/6)...
REM for /f %%i in ('%CompilerPath% %BatchPATH%merge.r MXF 2 %BatchPATH%') do set MXF2=%%i
REM if %MXF2% == success_yesToday ECHO Completed(5/6)~~

REM ::投信小台(6/6)...
REM for /f %%i in ('%CompilerPath% %BatchPATH%merge.r MXF 3 %BatchPATH%') do set MXF3=%%i
REM if %MXF3% == success_yesToday ECHO Completed(6/6)~~

REM ::合併全部新舊資料
REM for /f %%i in ('%CompilerPath% %BatchPATH%mergeAll.r %BatchPATH%') do set All=%%i
REM ECHO Completed(@@@)~~


ECHO #######  檢查資料是否正確 + 輸出log #######

REM SET DT=%DATE% %TIME%
REM SET ERROR=2

REM if %TXF1% == success_yesToday(Big3) if %TXF2% == success_yesToday(Big3) if %TXF3% == success_yesToday(Big3) if %MXF1% == success_yesToday(Big3) if %MXF2% == success_yesToday(Big3) if %MXF3% == success_yesToday(Big3) (
    
	REM ::若全部正確 ==> ERROR=0
	REM SET ERROR=0
	REM ECHO %DT%  Success(Big3) >> log\log.txt
	
	REM )
	
REM if %TXF1% == success_noToday(Big3) if %TXF2% == success_noToday(Big3) if %TXF3% == success_noToday(Big3) if %MXF1% == success_noToday(Big3) if %MXF2% == success_noToday(Big3) if %MXF3% == success_noToday(Big3) (
    
	REM ::若無當天資料 ==> ERROR=2
	REM SET ERROR=1
	REM ECHO %DT%  Success_noToday(Big3) >> log\log.txt
	
	REM )
	
REM if %ERROR% == 2	ECHO %DT%  Error(Big3) >> log\log.txt

REM ECHO %DT%  %TXF1% >> log\log.txt
REM ECHO %DT%  %TXF2% >> log\log.txt
REM ECHO %DT%  %TXF3% >> log\log.txt
REM ECHO %DT%  %MXF1% >> log\log.txt
REM ECHO %DT%  %MXF2% >> log\log.txt
REM ECHO %DT%  %MXF3% >> log\log.txt

ECHO %DT%  %All% >> log\log.txt

	
ECHO Finish


pause



