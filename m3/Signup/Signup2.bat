echo off
:START
REM 1 = Server. 1 = M3 2 = SOTSE.
REM 2 = Username max 6 characters as the script needs the other 4
REM 3 = Password you want given to each char created. use up to 10 characters.
REM 4 = Charname you want given to each char created. only use 6 characters. to allow room for numbering.
REM 5 = Number of mergers to make.
REM 6 = Custom Race advise less than 10 characters.
REM 7 = Friend. Add your friend chars name case sensitively. nofriend = no friend link.
perl Signup.pl 1 user6max pass10max name6max 10 customrace friend
perl -e sleep(2)
goto START
