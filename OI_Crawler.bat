
@ECHO OFF

ECHO Start

::���o�妸�ɩҦb�����|
SET BatchPATH=%~DP0
SET CompilerPath="C:\Program Files\R\R-3.4.4\bin\Rscript"
::SET CompilerPath="C:\Program Files\R\R-3.4.3\bin\Rscript"

ECHO #######  ���J��Ѹ�� #######

::���㫴����T(�̨������})
ECHO �j�p�x(�`OI)
%CompilerPath% %BatchPATH%MTX_Crawler.r TX %BatchPATH%
%CompilerPath% %BatchPATH%MTX_Crawler.r MTX %BatchPATH%
::%CompilerPath% %BatchPATH%MTX_Crawler.r MTX %BatchPATH% all

:: �T�j�k�H
ECHO �j�p�x(�T�j�k�H)...
%CompilerPath% %BatchPATH%Big3_Crawler.r TXF %BatchPATH%
%CompilerPath% %BatchPATH%Big3_Crawler.r MXF %BatchPATH% 

ECHO #######  �X�־��v��ƻP�s��� #######

::�X�֤T�j�k�H...
for /f %%i in ('%CompilerPath% %BatchPATH%mergeBig3.r %BatchPATH%') do set Big3=%%i
if %Big3% == success_yesToday(Big3) ECHO ^  Merge Big3 Completed @@@~~~
if %Big3% == success_noToday(Big3) ECHO ^  No today @@@~~~

::�X�֥����s�¸��
for /f %%i in ('%CompilerPath% %BatchPATH%mergeAll.r %BatchPATH%') do set All=%%i
if %All% == success_yesToday(All) ECHO ^  Merge All Completed @@@~~~
if %All% == success_noToday(All) ECHO ^  No today @@@~~~

ECHO #######  �ˬd��ƬO�_���T + ��Xlog #######

REM ::�]�w��Ѥ��
SET DT=%DATE% %TIME% 

ECHO %DT%  %Big3% >> log\log.txt
ECHO %DT%  %All% >> log\log.txt



	
ECHO Finish

::pause



