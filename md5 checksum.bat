@Echo off

cd %cd% 										&REM Move to current folder	

:begin
set "md5=" 										&REM Reset md5 value in looped, otherwise it will keep the previous value and the user won't be able to skip the matching
set /p "filename=Enter the filename to check (the batch file must be in the same folder) : "
set /p "md5=Enter the MD5 to compare with (or leave it blank and press enter to only display the MD5 of the file) : "

cls												&REM Clear console

Echo Checking the MD5, please wait...
Echo It may take a while depending on the file size.
								
For /F Delims^= %%G In ('CertUtil -HashFile "%filename%" MD5^|FindStr /VRC:"[^a-f 0-9]"')Do Set "filemd5=%%G" &REM only display the value of certUtil and remove unwanted lines from the command results
								
cls	

echo %filename% MD5 is:
echo %filemd5%

if "%md5%" equ "" goto end						&REM Skip the matching part if MD5 prompt has been left blank


REM vvvvv Matching section vvvvvv
echo The MD5 you want to compare with is:
echo %md5%
echo:											&REM Breakline
if /I "%filemd5%" equ "%md5%" (			
      echo [32m MD5 does match. [0m		&REM [32m to color the text to green (Windows 10 and newer) and  [0m to set color text back to default. Symbol is mandatory to make it work
) else (
      echo [31m MD5 does NOT match.[0m Please check that the MD5 value you entered is correct, eg no added space character
)
REM ^^^^^^ Matching section ^^^^^^


:end

echo:
Echo 1. To check another MD5 value, press any key to continue
Echo 2. To exit, close the window or press 'ALT+F4'
pause > nul										&REM Hide pause command output 'Press any key to continue . . .' to display my own text instead
cls

goto begin										&REM Loop the batch if user didn't exit
