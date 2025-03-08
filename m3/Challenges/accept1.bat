echo off
:START
REM Server User Pass Accept.
REM Server: 1 = M3 2 = ef.
REM User = Username.
REM Pass = Password.
REM Accept: Accept is the charname of the char from which you wish to accept challenges.
REM ~~ This can be a partial if you wish, e.i wig would accept challs from wiggles, earwig, thewiggler.
perl accept.pl 1 username password acceptname
perl -e sleep(2)
goto START
