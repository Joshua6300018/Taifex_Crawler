
@ECHO OFF

ECHO Start

::���o�妸�ɩҦb�����|
SET BatchPATH=%~DP0
SET CompilerPath="C:\Users\90813\Documents\R\R-3.4.3\bin\Rscript"
::SET CompilerPath="C:\Program Files\R\R-3.4.3\bin\Rscript"

ECHO #######  ���J��Ѹ�� #######

::���㫴����T(�̨������})
ECHO �j�p�x(�`OI)
%CompilerPath% %BatchPATH%MTX_Crawler.r TX %BatchPATH% all
%CompilerPath% %BatchPATH%MTX_Crawler.r MTX %BatchPATH% all

:: �T�j�k�H
ECHO �j�p�x(�T�j�k�H)...
%CompilerPath% %BatchPATH%Big3_Crawler.r TXF %BatchPATH%
%CompilerPath% %BatchPATH%Big3_Crawler.r MXF %BatchPATH% 

ECHO #######  �X�־��v��ƻP�s��� #######

REM ::�~��j�x(1/6)...
REM for /f %%i in ('%CompilerPath% %BatchPATH%merge.r TXF 1 %BatchPATH%') do set TXF1=%%i
REM if %TXF1% == success_yesToday ECHO Completed(1/6)~~

REM ::����j�x(2/6)...
REM for /f %%i in ('%CompilerPath% %BatchPATH%merge.r TXF 2 %BatchPATH%') do set TXF2=%%i
REM if %TXF2% == success_yesToday ECHO Completed(2/6)~~

REM ::��H�j�x(3/6)...
REM for /f %%i in ('%CompilerPath% %BatchPATH%merge.r TXF 3 %BatchPATH%') do set TXF3=%%i
REM if %TXF3% == success_yesToday ECHO Completed(3/6)~~

REM ::�~��p�x(4/6)...
REM for /f %%i in ('%CompilerPath% %BatchPATH%merge.r MXF 1 %BatchPATH%') do set MXF1=%%i
REM if %MXF1% == success_yesToday ECHO Completed(4/6)~~

REM ::����p�x(5/6)...
REM for /f %%i in ('%CompilerPath% %BatchPATH%merge.r MXF 2 %BatchPATH%') do set MXF2=%%i
REM if %MXF2% == success_yesToday ECHO Completed(5/6)~~

REM ::��H�p�x(6/6)...
REM for /f %%i in ('%CompilerPath% %BatchPATH%merge.r MXF 3 %BatchPATH%') do set MXF3=%%i
REM if %MXF3% == success_yesToday ECHO Completed(6/6)~~

REM ::�X�֥����s�¸��
REM for /f %%i in ('%CompilerPath% %BatchPATH%mergeAll.r %BatchPATH%') do set All=%%i
REM ECHO Completed(@@@)~~


ECHO #######  �ˬd��ƬO�_���T + ��Xlog #######

REM SET DT=%DATE% %TIME%
REM SET ERROR=2

REM if %TXF1% == success_yesToday(Big3) if %TXF2% == success_yesToday(Big3) if %TXF3% == success_yesToday(Big3) if %MXF1% == success_yesToday(Big3) if %MXF2% == success_yesToday(Big3) if %MXF3% == success_yesToday(Big3) (
    
	REM ::�Y�������T ==> ERROR=0
	REM SET ERROR=0
	REM ECHO %DT%  Success(Big3) >> log\log.txt
	
	REM )
	
REM if %TXF1% == success_noToday(Big3) if %TXF2% == success_noToday(Big3) if %TXF3% == success_noToday(Big3) if %MXF1% == success_noToday(Big3) if %MXF2% == success_noToday(Big3) if %MXF3% == success_noToday(Big3) (
    
	REM ::�Y�L��Ѹ�� ==> ERROR=2
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



