echo off
set var=1
:START
REM what to put below:
REM Server user pass loopwait chartype "Stealer Charname" "MergerName" Max Level.
REM User = Chars Username at login screen.
REM Pass = Chars Password at login screen.
REM Loopwait should start around 0.45
REM Chartype: 1 = agimage¦ 2 = fighter¦ 3 = mage¦ 4 = Pure Fighter¦ 5 = Pure Mage¦ 6 = ContraFighter
REM Chartype: 7 = str¦ 8 = dex¦ 9 = agil¦ 10 = int¦ 11 = conc¦ 12 = contra
REM Shops on or shops off 1 = on 2 = off
REM Max level stops your char leveling beyond the given number.
REM MAIN.PL USER PASS WAIT CHAR SHOP STEALER MERGER MAXLEVEL.
start /min perl mlv1.pl %var% 1 1 1 2510000000 Corbhelp8
timeout /t 3 /nobreak
SET /A var = %var% + 1
start /min perl mlv1.pl %var% 1 1 1 2510000000 Corbhelp8
timeout /t 3 /nobreak
SET /A var = %var% + 1
start /min perl mlv1.pl %var% 1 1 1 2510000000 Corbhelp8
timeout /t 3 /nobreak
SET /A var = %var% + 1
start /min perl mlv1.pl %var% 1 1 1 2510000000 Corbhelp8
timeout /t 3 /nobreak
SET /A var = %var% + 1
start /min perl mlv1.pl %var% 1 1 1 2510000000 Corbhelp8
timeout /t 60 /nobreak
SET /A var = %var% + 1
goto START

REM cmd /k perl mlv1.pl %var% 1 1 1 2510000000 Corbhelp8
REM timeout /t 10 /nobreak
REM SET /A var = %var% + 1
REM goto START