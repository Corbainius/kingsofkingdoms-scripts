echo off
:START
:: Debug mode 1 = on 2 = off
:: Requests mode 1 = on 2 = off
:: User = Chars Username at login screen.
:: Pass = Chars Password at login screen.
:: User and Pass fields can be condensed to one numeric field if using logins file method.
:: Standard wait is the time the script waits before every non-fight action.
:: Fightwait is the time the script waits before every fight and should start around 1.00.
:: Fight Mode 1 = AD 2 = AP 3 = SP
:: Chartype: 1 = agimage¦ 2 = fighter¦ 3 = mage¦ 4 = Pure Fighter¦ 5 = Pure Mage¦ 6 = ContraFighter 
:: Chartype: 7 = str¦ 8 = dex¦ 9 = agil¦ 10 = int¦ 11 = conc¦ 12 = contra 13 = SP with SS 14 = SP without SS
:: Shops on or shops off 1 = on 2 = off
:: Max level stops your char leveling beyond the given number.
:: If using chartype 13 or above you can use the 6 arguments after the max level to set a leveling ratio for your char for custom builds. You have 100 points to place as you see fit that must total 100 across the 6 arguments to create a ratio for leveling. You MUST use whole numbers.
::
:: change the entries after main.pl then run the .bat file. 
cmd /k perl -w main.pl 1 2 2 1.5 1.1 3 13 1 100000 10 20 20 10 20 20
perl -e sleep(2)
goto START
