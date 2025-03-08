echo off
:START
REM what to put below:
REM Server 1 = m3 2 = ef
REM Username
REM Password
REM User and Pass fields can be condensed to one numeric field if using logins file method.
REM wait = 0.85 is best
REM chartype: 1 = Agilmage 2 = Fighter 3 = Mage 4 = Pure fighter 5 = Pure mage 6 = Contra fighter.
REM charmbuild: 1 = Agilmage 2 = Fighter 3 = Mage 4 = Pure fighter 5 = Pure mage 6 = Contra fighter.
REM charmbuild: 7 = Str 8 = Dex 9 = Agil 10 = Int 11 = Conc 12 = Contra
REM Min charm quality = the sum of the stats for your build, like this str % + dex % for build fighter.
perl wcf.pl 1 1 1 1 1 50
perl -e sleep(2)
goto START
 