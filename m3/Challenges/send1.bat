echo off
:START
REM Server User Pass Proxy i.p Proxy port First use Send
REM Server: 1 = M3 2 = ef.
REM User: username
REM Pass: Password
REM Proxy I.P: you will have to find this yourself. The one i left here was working when i finished the script.
REM Proxy Port: this will be with the i.p you find
REM First Use: 2 = off 1 = on. Use this the first time you use a new i.p to see if it is working, then switch it back off once it's working.
REM Send: This is either a full charname not including title or a partial charname shared by the chars you wish to send too.
perl send.pl 1 username password 2 sendname
perl -e sleep(2)
goto START
