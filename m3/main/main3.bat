echo off
:START
:: -d after perl on the line below for debug mode. r and then enter to run the script.
:: Debug mode 1 = on 2 = off
:: Requests mode 1 = on 2 = off
:: Server: 1 = M3. 2 = EF.
:: User = Chars Username at login screen.
:: Pass = Chars Password at login screen.
:: User and Pass fields can be condensed to one numeric field if using logins file method.
:: Standard wait is the time the script waits before everyone non-fight action.
:: Fightwait should start around 1.00.
:: Chartype: 1 = agimage¦ 2 = fighter¦ 3 = mage¦ 4 = Pure Fighter¦ 5 = Pure Mage¦ 6 = ContraFighter
:: Chartype: 7 = str¦ 8 = dex¦ 9 = agil¦ 10 = int¦ 11 = conc¦ 12 = contra
:: Shops on or shops off 1 = on 2 = off
:: Stealer must have full name including title set to "no steal" if not stealing.
:: Merger may have partial name but MUST NOT include title. if not merging put "no merger".
:: Maxmergerlevel limits the level of the char you merge with.
:: Max level stops your char leveling beyond the given number.
:: DEBUG SERVER USER PASS STANDARDWAIT FIGHTWAIT BUILD SHOP STEALER MERGER MAXMERGERLEVEL MAXLEVEL.
:: change the entries after main.pl.
:: Debug Requests Server User Pass Standardwait Fightwait Chartype Shopsonoff "Stealer Charname" "MergerName" Maxmergerlevel MaxcharLevel.
cmd /k perl -w main.pl 2 2 1 1 1.2 1 1 1 "no stealer" "no merger" 100000 100000
perl -e sleep(2)
goto START
