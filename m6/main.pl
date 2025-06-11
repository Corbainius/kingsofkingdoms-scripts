#!/usr/bin/perl
use strict;
use warnings;
#s1(); infoformat("Perl version: $^V");
use integer;
use Carp;
use Math::BigFloat;
use Math::BigInt;
use Math::Round;
use Time::HiRes qw(sleep);
use WWW::Mechanize;
use POSIX qw(strftime);
use feature 'try';
use Cwd qw();
use Term::ANSIColor;
use threads;
use threads::shared;

logo("                                           
        www.kingsofkingdoms.com            
                                           
        888b     d888  .d8888b.            
        8888b   d8888 d88P  Y88b           
        88888b.d88888 888                  
        888Y88888P888 888d888b.            
        888 Y888P 888 888P \"Y88b           
        888  Y8P  888 888    888           
        888   \"   888 Y88b  d88P           
        888       888  \"Y8888P\"            
                                           
");

my $trigger = 0;

if ($#ARGV < 19){
	if ($ARGV[2] >= 1 && $ARGV[2] <= 999999){
		splice(@ARGV, 3, 0, ('password'));
		$trigger = 1;
	}
}	

if($ARGV[0] == 1){
	nl();s1();debug("Arguments:");
	foreach my $i (0..$#ARGV) {
		s1();debug("ARGV[$i] = $ARGV[$i]");
	}
	nl();
}

my $debug = defined $ARGV[0] ? $ARGV[0] : die errorformat("debug error in .bat");
my $requests = defined $ARGV[1] ? $ARGV[1] : die errorformat("requests error in .bat");
my $username = defined $ARGV[2] ? $ARGV[2] : die errorformat("username error in .bat");
my $password = defined $ARGV[3] ? $ARGV[3] : die errorformat("password error in .bat");
my $stime = defined $ARGV[4] ? $ARGV[4] : die errorformat("standard wait time in .bat");
my $loopwait = defined $ARGV[5] ? $ARGV[5] : die errorformat("loopwait error in .bat");
my $fmode = defined $ARGV[6] ? $ARGV[6] : die errorformat("fmode error in .bat");
my $chartype = defined $ARGV[7] ? $ARGV[7] : die errorformat("chartype error in .bat");
my $shopyesno = defined $ARGV[8] ? $ARGV[8] : die errorformat("Shops on or off in .bat");
my $maxlev = defined $ARGV[9] ? $ARGV[9] : die errorformat("maxlev error in .bat");
my $ratio0 = defined $ARGV[10] ? $ARGV[10] : die errorformat("ratio0 error in .bat");
my $ratio1 = defined $ARGV[11] ? $ARGV[11] : die errorformat("ratio1 error in .bat");
my $ratio2 = defined $ARGV[12] ? $ARGV[12] : die errorformat("ratio2 error in .bat");
my $ratio3 = defined $ARGV[13] ? $ARGV[13] : die errorformat("ratio3 error in .bat");
my $ratio4 = defined $ARGV[14] ? $ARGV[14] : die errorformat("ratio4 error in .bat");
my $ratio5 = defined $ARGV[15] ? $ARGV[15] : die errorformat("ratio5 error in .bat");


# Global variables
my($all, $stat);
my(@stats);
my(@logins);
my(@users);
my(@outcomes);
my($parsed,$tmp,$mech);
my($a,$b,$c,$d);
my($c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9);
my($str,$dex,$agil,$int,$conc,$contra);
my($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST);
my($clicks);
my($strlevs,$dexlevs,$agillevs,$intlevs,$conclevs,$contralevs);
my $ratiolevs;
my $users;
my $datestring;
my $charname;
my $title;
my $name = "";
my $DoSearch = "";
my $antal = new Math::BigFloat;
my $wdlevel = new Math::BigFloat;
my $aslevel = new Math::BigFloat;
my $mslevel = new Math::BigFloat;
my $deflevel = new Math::BigFloat;
my $arlevel = new Math::BigFloat;
my $mrlevel = new Math::BigFloat;
my $sdlevel = new Math::BigFloat;
my $sslevel = new Math::BigFloat;
my $srlevel = new Math::BigFloat;
my $level = new Math::BigFloat;
my $loopmulti = new Math::BigFloat;
my $mytime;
my $intstrlvl = 0;
my $autolevel;
my $MyLev;
my $ant1;
my $masslevel = 1500;
my $Alternate = 60;
my $agilmagecount = 6;
my $fightercount = 3;
my $magecount = 3;
my $puremagecount = 3;
my $purefightercount = 3;
my $cfcount = 17;
my $shop1;
my $shop2;
my $shop3;
my $shop4;
my $shop5;
my $shop6;
my $shop7;
my $shop8;
my $shop9;
my $shop10;
my $shop11;
my $shop12;
my $waitdiv = new Math::BigFloat;
my $exper3 = new Math::BigFloat;
my $experaverage = new Math::BigFloat;
my $reloadcount = 0;
my $gold3 = new Math::BigFloat;
my $goldaverage = new Math::BigFloat;
my $experseconds;
my $experminutes;
my $experhours;
my $experdays;
my $goldseconds;
my $goldminutes;
my $goldhours;
my $golddays;
my $Forlev;
my $Nextlevel = new Math::BigFloat;
my $SHOPMAX;
my $SHOPWEAP;
my $SHOPAS;
my $SHOPHS;
my $SHOPHELM;
my $SHOPSHIELD;
my $SHOPAMULET;
my $SHOPRING;
my $SHOPARMOR;
my $SHOPBELT;
my $SHOPPANTS;
my $SHOPHAND;
my $SHOPFEET;
my $URLSERVER;
my $filefix;
my $temp1 = new Math::BigFloat;
my $temploop = new Math::BigFloat;
my $purebuild = 180;
my $cpmready = 0;
my $fought;
my $of;
my $ofcounter;
my $foughtcounter;
my $capture;
my $avlevs=0;
my $perstat=0;
my $forstr = 0;
my $fordex = 0;
my $foragil = 0;
my $forint = 0;
my $forconc = 0;
my $forcontra = 0;
my $indefcont = 0;
my $trycounter = 0;
my $nos1=0;
my $fmodeval = 0;
my $output ="";
my $ant = 0;
my $ShopButton;
my $Sname;
my $proceed;
my $persist = 0;
my $levelfilename = '';
my $filelevel = '';
my $path = Cwd::cwd();
my $won = 0;
my $levmulti;
my $reps = 0;
my $setlev = 0;
my $tied = 0;
my $newlevel;
my $lost = 0;
my $tietrig = 0;
my $filename = '';
my $happened;
my $eighttwice = 0;
my $cpm;
my $cpmtest;
my $died;
my $aa;
my $firstlogin = 1;
my $namefix = '';
my $timer :shared;
my $seconds2 :shared = 0;
my $firsttitle = 0;

if($debug == 1){
	s1();debug("Debug mode active.");nl();
}

if($chartype == 7 or $chartype == 8 or $chartype == 9 or $chartype == 10 or $chartype == 11 or $chartype == 12){
	s1(); general("SINGLE STAT MODE, make sure you have selected the right stat.");
	$Alternate = 180;
	$shopyesno = 2;
}

if($chartype == 13 or $chartype == 14){
	s1(); general("Custom Stats build mode.");
	$Alternate = 100;
}

$URLSERVER = "/m6/";
$filefix = "m6";


if($fmode == 1){
	$fmodeval = "AD";
}elsif($fmode == 2){
	$fmodeval = "AP";
}elsif($fmode == 3){
	$fmodeval = "SP";
}

if(-d "AD"){}else{mkdir "AD";}
if(-d "AP"){}else{mkdir "AP";}
if(-d "SP"){}else{mkdir "SP";}

($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
$Year = $Year + 1900;
$Month = $Month + 1;
my $MonthName;

if($Month == 1){$MonthName = "January";
}elsif($Month == 2){$MonthName = "February";
}elsif($Month == 3){$MonthName = "March";
}elsif($Month == 4){$MonthName = "April";
}elsif($Month == 5){$MonthName = "May";
}elsif($Month == 6){$MonthName = "June";
}elsif($Month == 7){$MonthName = "July";
}elsif($Month == 8){$MonthName = "August";
}elsif($Month == 9){$MonthName = "September";
}elsif($Month == 10){$MonthName = "October";
}elsif($Month == 11){$MonthName = "November";
}elsif($Month == 12){$MonthName = "December";
}

$temploop = $loopwait * 10;
#---------------------
sub s1 {
	print " ";
}
sub s2 {
	print " " x 2;
}
sub s3 {
	print " " x 3;
}
sub s4 {
	print " " x 4;
}
sub nl {
	print "\n";
}
sub timer{
	print color('GREEN'),"Your script has been up for : ", $timer," ", color('reset');print "\n";
}
sub errorformat {
	print color('RED ON_BLUE')," ", @_," ", color('reset');print "\n";
}
sub warnformat {
	print color('RED ON_YELLOW')," ", @_," ", color('reset');print "\n";
}
sub infoformat {
	print color('YELLOW ON_BLUE')," ", @_," ", color('reset');print "\n";
}

sub debug {
	print color('BLUE ON_YELLOW ITALIC')," ", @_," ", color('reset');print "\n";
}
sub logo {
	print color('BOLD BRIGHT_BLUE ON_YELLOW'), @_, color('reset');print "\n";
}
sub general {
	print color('BLACK ON_WHITE')," ", @_," ", color('reset');print "\n";
}
sub won {
	print color('GREEN ON_BLUE')," ", @_," ", color('reset');print "\n";
}
sub draw {
	print color('YELLOW ON_BLUE')," ", @_," ", color('reset');print "\n";
}
sub lost {
	print color('RED ON_BLUE')," ", @_," ", color('reset');print "\n";
}

sub reset{
	print color('reset'), @_, color('reset');
}


#list of colours 
#black, red, green, yellow, blue, magenta, cyan, white

#list of bright colours
#bright_black, bright_red, bright_green, bright_yellow, bright_blue, bright_magenta, bright_cyan, bright_white

#list of background colours
#on_black, on_red, on_green, on_yellow, on_blue, on_magenta, on_cyan, on_white

#list of bright background colours
#on_bright_black, on_bright_red, on_bright_green, on_bright_yellow, on_bright_blue, on_bright_magenta, on_bright_cyan, on_bright_white

#list of attributes
#bold, faint, italic, underline, underscore, blink, reverse, concealed


#---------------------
# MAIN
#---------------------

# create a new browser
$mech = WWW::Mechanize->new(autocheck => 0, stack_depth => 1, onerror => \&Carp::croak);
$mech->agent_alias( 'Windows Mozilla' );

#Login
open(LOGINS, "m6logins.txt")
	or die "failed to open Logins file!!!!";
	@logins = <LOGINS>;
close(LOGINS);

if ($trigger == 1){
	if ($ARGV[1] >= 1 && $ARGV[1] <= 999999){
		my $logintakeone = $username - 1;
		@users = split(/ /, $logins[$logintakeone]);
		$username = $users[0];
		$password = $users[1];
		chomp ($username, $password);
	}
}

if($username eq ""){
	s1(); print"No logins found.";
	sleep($stime);
	goto RETRY;
}

&login;

my $levels = 9999999;

until($levels == 0){
	START:
	$levels--;
	&Charname;
	sleep(1.5);
	s1(); timer(); nl();
	&MyLevel;
	if($avlevs > $MyLev){&Autolevelup};
	&CheckShop;
	s1(); timer(); nl();
	&Cpmready;
	GOTO:
	if($cpmready == 0){
		nl(); s1(); general("Low Level Fight mode");nl();
	}else{
		nl(); s1(); general("High Level Fight mode");nl();
	}
	if($cpmready == 0){
		s1(); timer(); nl();
		&leveltestfight;
		s1(); timer(); nl();
		&LowFight;	
	}else{
		s1(); timer(); nl();
		&CPMlevel;
		s1(); timer(); nl();
		&Fight;
	}
}

goto RETRY;


#&leveltestworld; Written but not used yet

#seperate the output and error streams
#open STDOUT, '>>', 'output.txt' or die $!;
#open STDERR, '>>', 'Errorlog.txt' or die $!;

sub leveltestworld {
	LeveltestworldTop:
	$level = 0;
	$newlevel = 0;
	$levmulti = 0;
	
	if($debug == 1){
		s1(); debug("Arrived at leveltestworld");
	}

	$parsed = 0; 
	while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."world_control.php");
		$a = $mech->content();
		if($a =~ m/Town/){
			$parsed = 1;
		}
		$aa = $a;
		if($aa =~ m/(Stun time .*!<br>Please)/){
			$aa = $1;
			$aa =~ s/<br>Please//g;			
			s4(); warnformat($aa);nl();
			$aa =~ s/Stun time //g;
			$aa =~ s/!//g;
			$aa = $aa + 2;
			s4(); general("Please wait for the stun time to end.");nl();
			sleep($aa);
			$parsed = 0;
		}
	}

	if($debug == 1){
			s1(); debug($levelfilename);
	}

	my $fname = $levelfilename."-LevTestWORLD.txt";

	if($debug == 1){
		s1();debug($fname);
	}

	if(-e $fname){
		if($debug == 1){
			s1(); debug("File $fname exists");
		}
		open(FILE, "<".$fname)
		or die "failed to open file!!!!";
		my $found_line = 0;
		while (my $line = <FILE>) {
			chomp $line;
			if ($line) {
				$filelevel = $line;
				$found_line = 1;
			}
		}
		close(FILE);

		if (!$found_line) {
			open(FILE, ">>$fname") or die "failed to open file!!!!";
			print FILE "1\n";
			close(FILE);
			$filelevel = 1;
		}
		
		if($debug == 1){
			s1(); debug("filelevel = ".$filelevel.".");nl();
		}
	}else{
		if($debug == 1){
			s1(); debug("File $fname does not exists");
		}
		open(FILE, "+>".$fname)
		or die "failed to open file!!!!";
		print FILE "1";
		close(FILE);
		$filelevel = 1;
	}

	$won = 1;

	s1(); general("Basic level test starting at level ".$filelevel); nl();
	$levmulti = 0;
	while($won == 1){
		if(!$levmulti and $filelevel != 1){
			$levmulti = $filelevel;}
		elsif(!$levmulti){
			$levmulti = $filelevel;
		}else{
			$levmulti = $levmulti*2;
		}
		if($debug == 1){
			s1(); debug("levmulti = ".$levmulti);nl();
		}
		$level = $levmulti;
		$mech->form_number(2);
		$mech->field("Difficulty", $level);
		$mech->click();
		$a = $mech->content();

		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto LeveltestworldTop;
		}

		$a =~ m/(<select name="Monster">.*<\/form><form method=post>)/s;
		$a = $1;		
		sleep($loopwait); 
		$mech->click_button(value => $fmodeval);
		$b = $mech->content();

		if ($b =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
		}

		$b =~ m/(<tr><td>Level : .*.<\/font><\/body><\/html>)/s;
		$b = $1;

		$filename = $namefix."-TESTINFO1.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";		
			print FILE "\nTHIS IS A\nTHIS IS A\n";
			print FILE $a;
			print FILE "\nTHIS IS B\nTHIS IS B\n";
			print FILE $b;
			print FILE "\n";
			close(FILE);
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		if ($b =~ m/You win/) {
			s1(); won("You won at level ".$level);
			$won = 1;
			if($debug == 1){
				s1(); debug("levmulti = ".$levmulti);
			}
		}		
		if ($b =~ m/battle tied/) {
			s1(); draw("You tied at level ".$level);
			$won = 0;
			$level = $level; 
			if($debug == 1){
				s1(); debug("levmulti = ".$levmulti);
			}
			$tied++;
		}
		if ($b =~ m/stunned/) {
			s1(); lost("You lost at level ".$level);
			s1(); general("Waiting 5 seconds before continuing");
			$won = 0;
			$level = $level;
			if($debug == 1){
				s1(); debug("levmulti = ".$levmulti);
			}
			sleep(6);
		}
		if($b =~ m/jail time.*?!/){my $jailing = $1; 
			$jailing =~ s/jail time //g;
			$jailing =~ s/!//g;
			s4(); warnformat($1);nl();
			s4(); general("Please wait for the jail time to end.");nl();
			sleep($jailing);
			$parsed = 0;
		}
	}
	
	nl();s1(); general("Advanced level test starting at level ".$level); nl();

	if($debug == 1){
		s1(); debug("base level is ".$level);
	}
	
	until ($setlev == 1){
		LeveltestworldSetLev:
		$reps = 0;
		$won = 0;
		$tied = 0;
		$lost = 0;
		sleep($loopwait);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."world_control.php");		
		$a = $mech->content();

		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			until($a =~ m/Skeleton/){
				$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."world_control.php");
				$a = $mech->content();
				s1(); infoformat("still logged out, trying again.");
				sleep($stime);
			}
		}

		$mech->form_number(2);
		$mech->field("Difficulty", $level);
		$mech->click();
		$a = $mech->content();

		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto LeveltestworldSetLev;
		}

		$a =~ m/(<select name="Monster">.*<\/form><form method=post>)/s;
		$a = $1;		
		sleep($loopwait); 
		$mech->click_button(value => $fmodeval);
		$b = $mech->content();
		
		if ($b =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto LeveltestworldSetLev;
		}

		$b =~ m/(<tr><td>Level.*<form method=post)/s;
		$b = $1;

		$filename = $namefix."-TESTINFO1.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";		
			print FILE "\nTHIS IS A\nTHIS IS A\n";
			print FILE $a;
			print FILE "\nTHIS IS B\nTHIS IS B\n";
			print FILE $b;
			print FILE "\n";
			close(FILE);
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		if ($b =~ m/You win/) {
			$won++;
			$reps++; 
			$died = 0;
			s1(); won("Test fight ".$reps." You won at level ".$level);
		}
		if ($b =~ m/battle tied/) {
			$tied++;
			$reps++;
			$died = 0;
			s1(); draw("Test fight ".$reps." You tied at level ".$level);
		}
		if ($b =~ m/stunned/) {
			$lost++;
			$reps++;
			$died = 1;
			s1(); lost("Test fight ".$reps." You lost at level ".$level);
			nl(); s1(); general("Waiting 5 seconds before continuing");
			sleep(6);
		}
		if($b =~ m/jail time.*?!/){my $jailing = $1; 
			$jailing =~ s/jail time //g;
			$jailing =~ s/!//g;
			s4(); warnformat($1);nl();
			s4(); general("Please wait for the jail time to end.");nl();
			sleep($jailing);
			$parsed = 0;
		}

		until($reps == 10){
			if($died == 1){
				last();
			}else{
				$died = 0;
			}
			sleep($loopwait); 
			$mech->reload();
			$a = $mech->content();


			$b = $a;

			$filename = $namefix."-TESTINFO2.txt";
			if($debug == 1){
				open(FILE, ">>".$filename)
				or die "failed to open file!!!!";		
				print FILE "\nTHIS IS A\nTHIS IS A\n";
				print FILE $a;
				print FILE "\nTHIS IS B\nTHIS IS B\n";
				print FILE $b;
				print FILE "\n";
				close(FILE);
			}elsif($debug != 1){
				if(-e $filename){
					unlink($filename)or die "Can't delete $filename: $!\n";
					$filename = "";
				}else{
					$filename = "";
				}
			}else{
				warnformat("error in debug.");
			}

			if ($b =~ m/You win/) {
				$won++;
				$reps++;
				s1(); won("Test fight ".$reps." You won at level ".$level);
			}
			if ($b =~ m/battle tied/) {
				$tied++;
				$reps++;
				s1(); draw("Test fight ".$reps." You tied at level ".$level);
				if($tied >= 3){$tietrig = 1; $eighttwice = 0; last;}
			}
			if ($b =~ m/stunned/) {
				$lost++;
				$reps++;
				$eighttwice = 0;
				s1(); lost("Test fight ".$reps." You lost at level ".$level);
				s1(); general("Waiting 5 seconds before continuing");
				sleep(6);
				last;
			}
			if($b =~ m/jail time.*?!/){my $jailing = $1; 
				$jailing =~ s/jail time //g;
				$jailing =~ s/!//g;
				s4(); warnformat($1);nl();
				s4(); general("Please wait for the jail time to end.");nl();
				sleep($jailing);
				$parsed = 0;
			}
		}

		nl(); 
		@outcomes = ($won, $tied, $lost);
		my $i = 0;
		foreach(@outcomes) {
			if($i == 0){s1(); general("Won    "."$_");}elsif($i == 1){s1(); general("Tied   "."$_");}else{s1(); general("Lost   "."$_");}
			$i++;
		}
		nl(); 

		if($tietrig !=1){
			if($outcomes[0] >=8){ 
				s1(); general("Won 8 or more times."); nl();
				$newlevel = $level;
				$eighttwice++;
				if($eighttwice == 2){
					$setlev = 1;
					$eighttwice = 0;
					s1(); general("Level ".$newlevel." is set."); nl();
				}elsif($eighttwice == 1){
					s1(); general("Trying again at level ".$newlevel." for accuracy."); nl();
				}
			}elsif($outcomes[0] <=7 ){
				s1(); general("Won fewer than 8 times out of 10."); nl();
				if($debug == 1){
					s1(); debug("level = ".$level);
				}
				my $div10 = Math::BigFloat->new($level);
				$div10->bdiv(10);
				if($debug == 1){
					s1(); debug("div10 = ".$div10);
				}
				$div10->bfround(1);
				if($debug == 1){
					s1(); debug("rounded div10 = ".$div10);
				}
				$newlevel = $level - $div10;
				s1(); general("Trying level ".$newlevel); nl();
			}else{
				s1(); general("Wins error. Something is wrong\n");
			}
		}else{
			if($debug == 1){
				s1(); debug("TIETRIG TRIGGERED");nl();
				s1(); debug("level = ".$level);
			}
			s1(); general("Tied more than twice.");nl();
			my $div10 = Math::BigFloat->new($level);
			$div10->bdiv(10);
			if($debug == 1){
				s1(); debug("div10 = ".$div10);
			}
			$div10->bfround(1);
			if($debug == 1){
				s1(); debug("rounded div10 = ".$div10);
			}
			$newlevel = $level - $div10;
			s1(); general("Trying level ".$newlevel); nl();
			$tietrig = 0;
		}
		if($debug == 1){
			s1(); debug("Trying level ".$newlevel); nl();	
		}
		$level = $newlevel;
	}

	if($setlev == 1){
		if($debug == 1){
			s1(); debug("Trying level ".$newlevel); nl();
		}
		open(FILE, "+>".$fname)
		or die "failed to open file!!!!";
		print FILE "$newlevel";
		close(FILE);
		if($debug == 1){
			s1(); debug("filelevel updated sucessfully");
		}
		$setlev = 0;
	}

	return($newlevel);
}

sub leveltestfight {
	LeveltestfightTop:
	$level = 0;
	$newlevel = 0;
	$levmulti = 0;

	if($debug == 1){
		s1(); debug("Arrived at leveltestfight");
	}

	$parsed = 0;
	while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
		$a = $mech->content();
		if($a =~ m/Skeleton/){
			$parsed = 1;
		}
		$aa = $a;
		if($aa =~ m/(Stun time .*!<br>Please)/){
			$aa = $1;
			$aa =~ s/<br>Please//g;			
			s4(); warnformat($aa);nl();
			$aa =~ s/Stun time //g;
			$aa =~ s/!//g;
			$aa = $aa + 2;
			s4(); general("Please wait for the stun time to end.");nl();
			sleep($aa);
			$parsed = 0;
		}
	}

	if($debug == 1){
			s1(); debug($levelfilename);
	}

	my $fname =  $levelfilename."-LevTestFIGHT.txt";

	if($debug == 1){
		s1(); debug($fname);
	}
	if(-e $fname){
		if($debug == 1){
			s1(); debug("File $fname exists");
		}
		open(FILE, "<".$fname)
		or die "failed to open file!!!!";
		my $found_line = 0;
		while (my $line = <FILE>) {
			chomp $line;
			if ($line) {
				$filelevel = $line;
				$found_line = 1;
			}
		}
		close(FILE);

		if (!$found_line) {
			open(FILE, ">>$fname") or die "failed to open file!!!!";
			print FILE "1\n";
			close(FILE);
			$filelevel = 1;
		}
		
		if($debug == 1){
			s1(); debug("filelevel = ".$filelevel);nl();
		}
	}else{
		if($debug == 1){
			s1(); debug("File $fname does not exists");
		}
		open(FILE, "+>".$fname)
		or die "failed to open file!!!!";
		print FILE "1";
		close(FILE);
		$filelevel = 1;
	}

	$won = 1;

	s1(); general("Basic level test starting at level ".$filelevel); nl();
	$levmulti = 0;
	while($won == 1){
		if(!$levmulti and $filelevel != 1){
			$levmulti = $filelevel;}
		elsif(!$levmulti){
			$levmulti = $filelevel;
		}else{
			$levmulti = $levmulti*2;
		}
		if($debug == 1){
			s1(); debug("levmulti = ".$levmulti);nl();
		}
		$level = $levmulti;
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
		$a = $mech->content();
		
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			until($a =~ m/Skeleton/){
				$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
				$a = $mech->content();
				s1(); infoformat("still logged out, trying again.");
				sleep($stime);
			}
		}

		$mech->form_number(2);
		$mech->field("Difficulty", $level);
		$mech->click();
		$a = $mech->content();
		
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto LeveltestfightTop;
		}

		$a =~ m/(<select name="Monster">.*<\/form><form method=post>)/s;
		$a = $1;
		sleep($loopwait); 
		$mech->click_button(value => $fmodeval);
		$b = $mech->content();
		
		if ($b =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto LeveltestfightTop;	
		}

		$b =~ m/(<tr><td>Level : .*.<\/font><\/body><\/html>)/s;
		$b = $1;

		$filename = $namefix."-TESTINFO1.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";		
			print FILE "\nTHIS IS A\nTHIS IS A\n";
			print FILE $a;
			print FILE "\nTHIS IS B\nTHIS IS B\n";
			print FILE $b;
			print FILE "\n";
			close(FILE);
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		if ($b =~ m/You win/) {
			s1(); won("You won at level ".$level);
			$won = 1;
			if($debug == 1){
				s1(); debug("levmulti = ".$levmulti);
			}
		}		
		if ($b =~ m/battle tied/) {
			s1(); draw("You tied at level ".$level);
			$won = 0;
			$level = $level;
			if($debug == 1){
				s1(); debug("levmulti = ".$levmulti);
			}
			$tied++;
		}
		if ($b =~ m/stunned/) {
			s1(); lost("You lost at level ".$level);
			s1(); general("Waiting 5 seconds before continuing");
			$won = 0;
			$level = $level;
			if($debug == 1){
				s1(); debug("levmulti = ".$levmulti);
			}
			sleep(6);
		}
		if($b =~ m/jail time.*?!/){my $jailing = $1; 
			$jailing =~ s/jail time //g;
			$jailing =~ s/!//g;
			s4(); warnformat($1);nl();
			s4(); general("Please wait for the jail time to end.");nl();
			sleep($jailing);
			$parsed = 0;
		}
	}

	nl();s1(); general("Advanced level test starting at level ".$level); nl();

	if($debug == 1){
		s1(); debug("base level is ".$level);
	}
	
	until ($setlev == 1){
		LeveltestfightSetLev:
		$reps = 0;
		$won = 0;
		$tied = 0;
		$lost = 0;
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
		$a = $mech->content();
				
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			until($a =~ m/Skeleton/){
				$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
				$a = $mech->content();
				s1(); infoformat("still logged out, trying again.");
				sleep($stime);
			}
		} 

		$mech->form_number(2);
		$mech->field("Difficulty", $level);
		$mech->click();
		$a = $mech->content();
				
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
		}

		$a =~ m/(<select name="Monster">.*<\/form><form method=post>)/s;
		$a = $1;
		$mech->click_button(value => $fmodeval);
		sleep($loopwait); 
		$b = $mech->content();
				
		if ($b =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto LeveltestfightSetLev;
		}

		$b =~ m/(<td valign=top>Level.*<form method=post)/s;
		$b = $1;

		$filename = $namefix."-TESTINFO2.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";		
			print FILE "\nTHIS IS A\nTHIS IS A\n";
			print FILE $a;
			print FILE "\nTHIS IS B\nTHIS IS B\n";
			print FILE $b;
			print FILE "\n";
			close(FILE);
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		if ($b =~ m/You win/) {
			$won++;
			$reps++;
			$died = 0; 
			s1(); won("Test fight ".$reps." You won at level ".$level)
		}
		if ($b =~ m/battle tied/) {
			$tied++;
			$reps++;
			$died = 0;
			s1(); draw("Test fight ".$reps." You tied at level ".$level);
		}
		if ($b =~ m/stunned/) {
			$lost++;
			$reps++;
			$died = 1;
			s1(); lost("Test fight ".$reps." You lost at level ".$level);
			s1(); general("Waiting 5 seconds before continuing");
			sleep(6);
		}		
		if($b =~ m/jail time.*?!/){
			my $jailing = $1; 
			$jailing =~ s/jail time //g;
			$jailing =~ s/!//g;
			s4(); warnformat($1);nl();
			s4(); general("Please wait for the jail time to end.");nl();
			sleep($jailing);
			$parsed = 0;
		}
		
		until($reps == 10){
			LeveltestfightReps:
			if($died == 1){
				last();
			}else{
				$died = 0;
			}
			sleep($loopwait); 
			$mech->reload();
			$a = $mech->content();
					
			if ($a =~ m/logged/) {
				s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
				sleep(2);
				my $relogin_thread = threads->create(\&login);
				$relogin_thread->join();
				goto LeveltestfightReps;
			}

			$b = $a;

			$filename = $namefix."-TESTINFO2.txt";
			if($debug == 1){
				open(FILE, ">>".$filename)
				or die "failed to open file!!!!";		
				print FILE "\nTHIS IS A\nTHIS IS A\n";
				print FILE $a;
				print FILE "\nTHIS IS B\nTHIS IS B\n";
				print FILE $b;
				print FILE "\n";
				close(FILE);
			}elsif($debug != 1){
				if(-e $filename){
					unlink($filename)or die "Can't delete $filename: $!\n";
					$filename = "";
				}else{
					$filename = "";
				}
			}else{
				warnformat("error in debug.");
			}

			if ($b =~ m/You win/) {
				$won++;
				$reps++;
				s1(); won("Test fight ".$reps." You won at level ".$level);
			}
			if ($b =~ m/battle tied/) {
				$tied++;
				$reps++;
				s1(); draw("Test fight ".$reps." You tied at level ".$level);
				if($tied >= 3){$tietrig = 1; $eighttwice = 0; last;}
			}
			if ($b =~ m/stunned/) {
				$lost++;
				$reps++;
				$eighttwice = 0;
				s1(); lost("Test fight ".$reps." You lost at level ".$level);
				s1(); general("Waiting 5 seconds before continuing");
				sleep(6);
				last;
			}
			if($b =~ m/jail time.*?!/){my $jailing = $1; 
				$jailing =~ s/jail time //g;
				$jailing =~ s/!//g;
				s4(); warnformat($1);nl();
				s4(); general("Please wait for the jail time to end.");nl();
				sleep($jailing);
				$parsed = 0;
			}
		}

		nl(); 
		@outcomes = ($won, $tied, $lost);
		my $i = 0;
		foreach(@outcomes) {
			if($i == 0){s1(); general("Won    "."$_");}elsif($i == 1){s1(); general("Tied   "."$_");}else{s1(); general("Lost   "."$_");}
			$i++;
		}
		nl(); 

		if($tietrig !=1){
			if($outcomes[0] >=8){ 
				s1(); general("Won 8 or more times."); nl();
				$newlevel = $level;
				$eighttwice++;
				if($eighttwice == 2){
					$setlev = 1;
					$eighttwice = 0;
					s1(); general("Level ".$newlevel." is set."); nl();
				}elsif($eighttwice == 1){
					s1(); general("Trying again at level ".$newlevel." for accuracy."); nl();
				}
			}elsif($outcomes[0] <=7 ){
				s1(); general("Won fewer than 8 times out of 10."); nl();
				if($debug == 1){
					s1(); debug("level = ".$level);
				}
				my $div10 = Math::BigFloat->new($level);
				$div10->bdiv(10);
				if($debug == 1){
					s1(); debug("div10 = ".$div10);
				}
				$div10->bfround(1);
				if($debug == 1){
					s1(); debug("rounded div10 = ".$div10);
				}
				$newlevel = $level - $div10;
				s1(); general("Trying level ".$newlevel); nl();
			}else{
				s1(); general("Wins error. Something is wrong\n");
			}
		}else{
			if($debug == 1){
				s1(); debug("TIETRIG TRIGGERED");nl();
				s1(); debug("level = ".$level);
			}
			s1(); general("Tied more than twice.");nl();
			my $div10 = Math::BigFloat->new($level);
			$div10->bdiv(10);
			if($debug == 1){
				s1(); debug("div10 = ".$div10);
			}
			$div10->bfround(1);
			if($debug == 1){
				s1(); debug("rounded div10 = ".$div10);
			}
			$newlevel = $level - $div10;
			s1(); general("Trying level ".$newlevel); nl();
			$tietrig = 0;
		}
		if($debug == 1){
			s1(); debug("level ".$level); nl();
			s1(); debug("Trying level ".$newlevel); nl();	
		}
		$level = $newlevel;
	}

	if($setlev == 1){
		if($debug == 1){
			s1(); debug("Trying level ".$newlevel); nl();
		}
		open(FILE, "+>".$fname)
		or die "failed to open file!!!!";
		print FILE "$newlevel";
		close(FILE);
		if($debug == 1){
			s1(); debug("filelevel updated sucessfully");
		}
		$setlev = 0;
	}

	return($newlevel);
}

sub LowFight {
	LowfightTop:
	if($debug == 1){
		s1(); debug("Arrived at LowFight");
	}

	my($cpm);
	$parsed = 0;
	while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
		$a = $mech->content();
		if($a =~ m/Skeleton/){
			$parsed = 1;
		}
		$aa = $a;
		if($aa =~ m/(Stun time .*!<br>Please)/){
			$aa = $1;
			$aa =~ s/<br>Please//g;			
			s4(); warnformat($aa);nl();
			$aa =~ s/Stun time //g;
			$aa =~ s/!//g;
			$aa = $aa + 2;
			s4(); general("Please wait for the stun time to end.");nl();
			sleep($aa);
			$parsed = 0;
		}
	}
	
	$filename = $namefix."-LowFight.txt";
	if($debug == 1){
		open(FILE, ">>".$filename)
		or die "failed to open file!!!!";
		print FILE "LowFight\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		s1(); debug("LowFight");
	}elsif($debug != 1){
		if(-e $filename){
			unlink($filename)or die "Can't delete $filename: $!\n";
			$filename = "";
		}else{
			$filename = "";
		}
	}else{
		warnformat("error in debug.");
	}

	$mech->form_number(2);
	$mech->field("Difficulty", $newlevel);
	$mech->click();
	sleep($loopwait);
	$mech->click_button(value => $fmodeval);
	$a = $mech->content();
			
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto LowfightTop;
		}

	$filename = $namefix."-LowFight2.txt";
	if($debug == 1){
		open(FILE, ">>".$filename)
		or die "failed to open file!!!!";
		print FILE "LowFight2\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		s1(); debug("LowFight2");
	}elsif($debug != 1){
		if(-e $filename){
			unlink($filename)or die "Can't delete $filename: $!\n";
			$filename = "";
		}else{
			$filename = "";
		}
	}else{
		warnformat("error in debug.");
	}

	$ant = 1800;
	$ant1 = new Math::BigFloat $ant;
	my$divided = new Math::BigFloat $loopwait;
	if ($loopwait <= 0.3){$divided = 0.4;}
	if ($loopwait >= 1.0){$divided = 0.9;}
	$divided = $divided*100;
	$divided = $divided/90;
	$ant1->bdiv($divided);
	$ant1->bstr();
	$ant1->bfround(1);
	$antal = $ant1;
	if($antal >= 3600){
	   $antal = 3600;
	} 

 	#REPEAT:

	while($antal > 0) {
		LowfightAntal:
		sleep($loopwait); 
		$antal = $antal -1;
		my $retries = 0;
		retry:
		$mech->reload();
		$a = $mech->content();
				
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto LowfightAntal;	
		}

		$filename = $namefix."-LowFight3.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "LowFight3\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);
			
			s1(); debug("LowFight3");
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		$b = $a;
		$c = $a;
		$d = $mech->status();
		if($d == 500 or $d == 400){
			if($retries == 0){
				if($d == 400){
					s1(); errorformat("400 error");
				}else{
					s1(); infoformat("Trouble Connecting to internet....Probably.");
				}
			}
			until ($d == 200){
				$retries = $retries +1;
				if($retries == 5){
					goto RETRY;
				}
				sleep($stime);
				goto retry;
			}
		}
			
	#KILLED
		if($a =~ m/(been.*slain)/) {
			s1(); lost( "You were slain!");
		}
	#LOGGED OUT
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
		}
		if ($antal <= 0) {
			sleep(3);
			s1(); infoformat("Waiting last few seconds before restarting");
			goto START;
		}
		if ($a =~ m/(400 Bad Request)/){s1(); errorformat("400 error restarting.");
			goto START;
		}

		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		$output = "Output was not set";
		if($b =~ m/(You win .*? exp)/){$output = $1;
		$happened = 1;}
		if($b =~ m/(The battle tied)/){$output = $1;$happened = 2;}
		if($b =~ m/jail time.*?!/){$output = $1;$happened = 3;}
		if($b =~ m/logged/){$output = "You were logged back in.";$happened = 4;}
		if($b =~ m/(Stun time .*!<br>Please)/){
			$c = $1;
			$c =~ s/<br>Please//g;
			$output = $c;
			$happened = 5;
		}
		if($b =~ m/(stunned for .* seconds.)/){
			$output = $1;
			$happened = 6;
		}

		if($happened == 1){
			s1(); won("$antal: [$Hour:$Minute:$Second]: " . $output);
			$happened = 0;
		}elsif($happened == 2){
			s1(); draw("$antal: [$Hour:$Minute:$Second]: " . $output);
			$happened = 0;
		}elsif($happened == 3){
			s1(); warnformat("$antal: [$Hour:$Minute:$Second]: " . $output);
			$happened = 0;
		}elsif($happened == 4){
			s1(); warnformat("$antal: [$Hour:$Minute:$Second]: " . $output);
			$happened = 0;
		}elsif($happened == 5){
			s1(); warnformat("$antal: [$Hour:$Minute:$Second]: " . $output);
			$happened = 0;
		}elsif($happened == 6){
			s1(); warnformat("$antal: [$Hour:$Minute:$Second]: " . $output);
			$happened = 0;
		}else{
			s1(); errorformat($antal.":"."[".$Hour.":".$Minute.":".$Second."] : Something isn't right with output in lowfight");
		}

		if (($b =~ m/(Level up.*HERE!)/) and ($indefcont != 1)) {
			if($persist == 100){
				$persist = 0;
				&Levelup;
			}else{
				$persist++;
				if($debug == 1){
					s1(); debug("Skipping levelup 100 times. persist = ".$persist);
				}
			}
		}
	}
}

sub Autolevelup {
	AutolevelupTop:
	if($debug == 1){
		s1(); debug("Arrived at Autolevelup");
	}

	$parsed = 0; 
	while ($parsed == 0) {
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."stats.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
		}
		$aa = $a;
		if($aa =~ m/(Stun time .*!<br>Please)/){
			$aa = $1;
			$aa =~ s/<br>Please//g;			
			s4(); warnformat($aa);nl();
			$aa =~ s/Stun time //g;
			$aa =~ s/!//g;
			$aa = $aa + 2;
			s4(); general("Please wait for the stun time to end.");nl();
			sleep($aa);
			$parsed = 0;
		}
	}

	$filename = $namefix."-Autolevelup.txt";
	if($debug == 1){
		open(FILE, ">>".$filename)
		or die "failed to open file!!!!";
		print FILE "Autolevelup\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		s1(); debug("Autolevelup");
	}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}
	$a = $mech->content();
					
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto AutolevelupTop;
		}

	$b = $a;
	
		$avlevs = $a;
		$avlevs =~ m/(You have .* levels available)/;
		$avlevs = $1;
		$avlevs =~ s/You have //s;
		$avlevs =~ s/ levels available//s;
		$avlevs =~ s/,//gs;

	my $ActualLevel = $MyLev;
	$b =~ m/(Level : .*Exp :)/;
	$b = $1;
	my $accclev = $b;
	$b =~ s/<\/td> .*//si;
	$b =~ s/Level : //si;
	$ActualLevel = $b;
	$accclev =~ s/,//sig;
	$accclev =~ m/(\d+)/;
	$accclev = $1;

	if($chartype == 6){
		$Alternate = 75;
	}
	if($a =~ m/(You have .* levels)/){
		$a = $1;
		$a =~ s/You have //s;
		$a =~ s/ levels//s;
		$a =~ s/,//gs;
		if($a+$accclev >= $maxlev){
			$a = $maxlev-$accclev;
		}
		if ($chartype == 1) {
			$perstat = $a/7;
			$perstat = int($perstat);
			$str = 0;
			$dex = 0;
			$agil = $perstat*3;
			$int = $perstat*3;
			$conc = $perstat;
			$contra = 0;
		}
		if ($chartype == 2) {
			$perstat = $a/4;
			$perstat = int($perstat);
			$str = $perstat*2;
			$dex = $perstat;
			$agil = 0;
			$int = 0;
			$conc = $perstat;
			$contra = 0;
		}
		if ($chartype == 3) {
			$perstat = $a/4;
			$perstat = int($perstat);
			$str = 0;
			$dex = $perstat;
			$agil = 0;
			$int = $perstat*2;
			$conc = $perstat;
			$contra = 0;
		}
		if ($chartype == 4) {
			$perstat = $a/4;
			$perstat = int($perstat);
			$str = $perstat;
			$dex = $perstat*3;
			$agil = 0;
			$int = 0;
			$conc = 0;
			$contra = 0;
		}		
		if ($chartype == 5) {
			$perstat = $a/4;
			$perstat = int($perstat);
			$str = 0;
			$dex = 0;
			$agil = 0;
			$int = $perstat;
			$conc = $perstat*3;
			$contra = 0;
		}
		if ($chartype == 6) {
			$perstat = $a/17;
			$perstat = int($perstat);
			$str = $perstat*3;
			$dex = $perstat*4;
			$agil = 0;
			$int = 0;
			$conc = 0;
			$contra = $perstat*10;
		}
		if ($chartype == 7) {
			$perstat = $a;
			$perstat = int($perstat);
			$str = $perstat;
			$dex = 0;
			$agil = 0;
			$int = 0;
			$conc = 0;
			$contra = 0;
		}
		if ($chartype == 8) {
			$perstat = $a;
			$perstat = int($perstat);
			$str = 0;
			$dex = $perstat;
			$agil = 0;
			$int = 0;
			$conc = 0;
			$contra = 0;
		}
		if ($chartype == 9) {
			$perstat = $a;
			$perstat = int($perstat);
			$str = 0;
			$dex = 0;
			$agil = $perstat;
			$int = 0;
			$conc = 0;
			$contra = 0;
		}
		if ($chartype == 10) {
			$perstat = $a;
			$perstat = int($perstat);
			$str = 0;
			$dex = 0;
			$agil = 0;
			$int = $perstat;
			$conc = 0;
			$contra = 0;
		}
		if ($chartype == 11) {
			$perstat = $a;
			$perstat = int($perstat);
			$str = 0;
			$dex = 0;
			$agil = 0;
			$int = 0;
			$conc = $perstat;
			$contra = 0;
		}
		if ($chartype == 12) {
			$perstat = $a;
			$perstat = int($perstat);
			$str = 0;
			$dex = 0;
			$agil = 0;
			$int = 0;
			$conc = 0;
			$contra = $perstat;
		}
		if ($chartype == 13 or $chartype == 14) {
			if($a>100){
				$perstat = $a/100;
				$perstat = int($perstat);
				$str = $perstat*$ratio0;
				$dex = $perstat*$ratio1;
				$agil = $perstat*$ratio2;
				$int = $perstat*$ratio3;
				$conc = $perstat*$ratio4;
				$contra = $perstat*$ratio5;
			}else{
				s1(); general("Skipping autolevel because there are less than 100 levels to level.");
				return();
			}

		}
		$mech->form_number(1);
		$mech->field("Strength", $str);
		$mech->field("Dexterity", $dex);
		$mech->field("Agility", $agil);
		$mech->field("Intelligence", $int);
		$mech->field("Concentration", $conc);
		$mech->field("Contravention", $contra);
		sleep($stime);
		$mech->click_button('value' => 'Level Up!!!');
		$a = $mech->content();
						
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto AutolevelupTop;	
		}

		$b = $a;
		$c = $a;
		$b =~ m/(Level : .*Exp :)/;
		$b = $1;
		$b =~ s/<\/td> .*//si;
		$b =~ s/Level : //si;
		$b =~ s/,//gsi;
		$c =~ m/(You leveled up .* levels!)/;
		$c = $1;
		$c =~ s/,//gsi;
		$c =~ s/\D//gsi;
		$ActualLevel = $b + $c;
		my $FormatedLev = $ActualLevel;
		while($FormatedLev =~ m/([0-9]{4})/){
		my $temp1 = reverse $FormatedLev;
		$temp1 =~ s/(?<=(\d\d\d))(?=(\d))/,/;
		$FormatedLev = reverse $temp1;
		}
		my $Formatedc = $c;
		while($Formatedc =~ m/([0-9]{4})/){
		my $temp1 = reverse $Formatedc;
		$temp1 =~ s/(?<=(\d\d\d))(?=(\d))/,/;
		$Formatedc = reverse $temp1;
		}
		if($str>=1){
			$forstr = $str;
			while($forstr =~ m/([0-9]{4})/){
			my $temp1 = reverse $forstr;
			$temp1 =~ s/(?<=(\d\d\d))(?=(\d))/,/;
			$forstr = reverse $temp1;
			}
		}
		if($int>=1){
			$forint = $int;
			while($forint =~ m/([0-9]{4})/){
			my $temp1 = reverse $forint;
			$temp1 =~ s/(?<=(\d\d\d))(?=(\d))/,/;
			$forint = reverse $temp1;
			}
		}
		if($conc>=1){
			$forconc = $conc;
			while($forconc =~ m/([0-9]{4})/){
			my $temp1 = reverse $forconc;
			$temp1 =~ s/(?<=(\d\d\d))(?=(\d))/,/;
			$forconc = reverse $temp1;
			}
		}
		if($dex>=1){
			$fordex = $dex;
			while($fordex =~ m/([0-9]{4})/){
			my $temp1 = reverse $fordex;
			$temp1 =~ s/(?<=(\d\d\d))(?=(\d))/,/;
			$fordex = reverse $temp1;
			}
		}
		if($agil>=1){
			$foragil = $agil;
			while($foragil =~ m/([0-9]{4})/){
			my $temp1 = reverse $foragil;
			$temp1 =~ s/(?<=(\d\d\d))(?=(\d))/,/;
			$foragil = reverse $temp1;
			}
		}
		if($contra>=1){
			$forcontra = $contra;
			while($forcontra =~ m/([0-9]{4})/){
			my $temp1 = reverse $forcontra;
			$temp1 =~ s/(?<=(\d\d\d))(?=(\d))/,/;
			$forcontra = reverse $temp1;
			}
		}
	
		if($c >= 1){
			if($str>=1){s1(); general("[Level : $FormatedLev] You Auto-Leveled ".$forstr ." Strength");nl();}
			if($dex>=1){s1(); general("[Level : $FormatedLev] You Auto-Leveled ".$fordex ." Dexterity");nl();}
			if($agil>=1){s1(); general("[Level : $FormatedLev] You Auto-Leveled ".$foragil ." Agility");nl();}
			if($int>=1){s1(); general("[Level : $FormatedLev] You Auto-Leveled ".$forint ." Intelligence");nl();}
			if($conc>=1){s1(); general("[Level : $FormatedLev] You Auto-Leveled ".$forconc ." Concentration");nl();}
			if($contra>=1){s1(); general("[Level : $FormatedLev] You Auto-Leveled ".$forcontra ." Contravention");nl();}
			&CheckShop;
		}else{
			s1(); general("Did not auto level.");
		}
	}
	return();
}

sub CPMlevel {
	CpmlevelTop:
	if($debug == 1){
		s1(); debug("Arrived at cpmlevel");
	}

	$parsed = 0;
	while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
		$a = $mech->content();
		if($a =~ m/Skeleton/){
			$parsed = 1;
		}
		$aa = $a;
		if($aa =~ m/(Stun time .*!<br>Please)/){
			$aa = $1;
			$aa =~ s/<br>Please//g;			
			s4(); warnformat($aa);nl();
			$aa =~ s/Stun time //g;
			$aa =~ s/!//g;
			$aa = $aa + 2;
			s4(); general("Please wait for the stun time to end.");nl();
			sleep($aa);
			$parsed = 0;
		}
	}

	if($debug == 1){
			s1(); debug($levelfilename);
	}

	my $fname =  $levelfilename."-LevTestCPM.txt";
	if($debug == 1){
		s1(); debug($fname);
	}
	if(-e $fname){
		if($debug == 1){
			s1(); debug("File $fname exists");
		}
		open(FILE, "<".$fname)
		or die "failed to open file!!!!";
		my $found_line = 0;
		while (my $line = <FILE>) {
			chomp $line;
			if ($line) {
				$filelevel = $line;
				$found_line = 1;
			}
		}
		close(FILE);
		
		if (!$found_line) {
			open(FILE, ">>$fname") or die "failed to open file!!!!";
			print FILE "1\n";
			close(FILE);
			$filelevel = 1;
		}
		
		if($debug == 1){
			s1(); debug("filelevel = ".$filelevel);nl();
		}
	}else{
		if($debug == 1){
			s1(); debug("File $fname does not exists");
		}
		open(FILE, "+>".$fname)
		or die "failed to open file!!!!";
		print FILE "1";
		close(FILE);
		$filelevel = 201;
	}

	if ($filelevel < 201){
		$filelevel = 201;
	}


	$won = 1;

	s1(); general("Basic CPM level test starting at level ".$filelevel); nl();

	$levmulti = 0;
	while($won == 1){
		if(!$levmulti and $filelevel != 201){
			$levmulti = $filelevel;}
		elsif(!$levmulti){
			$levmulti = $filelevel;
		}else{
			$levmulti = $levmulti*2;
		}
		if($debug == 1){
			s1(); debug("levmulti = ".$levmulti);nl();
		}
		$level = $levmulti;
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
		$a = $mech->content();
		
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			until($a =~ m/Skeleton/){
				$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
				$a = $mech->content();
				s1(); infoformat("still logged out, trying again.");
				sleep($stime);
			}
		}

		$mech->form_number(2);
		$mech->field("Difficulty", $level);
		$mech->click_button(value => "Level");
		$a = $mech->content();
						
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto CpmlevelTop;
		}

		$cpm = $a;
		$cpm =~ m/(<option>208.*<\/option><option>209)/;
		$cpm = $1;
		$cpm =~ s/<\/option><option>209//g;
		$cpm =~ s/<option>//;

		if($debug == 1){
			s1(); debug("cpm = ".$cpm);
		}

		$a =~ m/(<select name="Monster">.*<\/form><form method=post>)/s;
		$a = $1;
		$b = $mech->content();
								
		if ($b =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto CpmlevelTop;
		}

		$b =~ m/(<td valign=top>Level.*<form method=post)/s;
		$b = $1;

			$filename = $namefix."-cpmINFO1.txt";
			if($debug == 1){
				open(FILE, ">>".$filename)
				or die "failed to open file!!!!";		
				print FILE "\nTHIS IS A\nTHIS IS A\n";
				print FILE $a;
				print FILE "\nTHIS IS B\nTHIS IS B\n";
				print FILE $b;
				print FILE "\n";
				close(FILE);
			}elsif($debug != 1){
				if(-e $filename){
					unlink($filename)or die "Can't delete $filename: $!\n";
					$filename = "";
				}else{
					$filename = "";
				}
			}else{
				warnformat("error in debug.");
			}
		$mech->select("Monster", $cpm);
		sleep($loopwait); 
		$mech->click_button(value => $fmodeval);
		$c = $mech->content();
								
		if ($c =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto CpmlevelTop;
		}

		$c =~ m/(<tr><td>Level : .*.<\/font><\/body><\/html>)/s;
		$c = $1;

			$filename = $namefix."-cpmINFO2.txt";
			if($debug == 1){
				open(FILE, ">>".$filename)
				or die "failed to open file!!!!";
				print FILE "\nTHIS IS C\nTHIS IS C\n";
				print FILE $c;
				print FILE "\n";
				close(FILE);
			}elsif($debug != 1){
				if(-e $filename){
					unlink($filename)or die "Can't delete $filename: $!\n";
					$filename = "";
				}else{
					$filename = "";
				}
			}else{
				warnformat("error in debug.");
			}

		if ($c =~ m/You win/) {
			s1(); won("You won at level ".$level);
			$won = 1;
			if($debug == 1){
				s1(); debug("levmulti = ".$levmulti);
			}
		}		
		if ($c =~ m/battle tied/) {
			s1(); draw("You tied at level ".$level);
			$won = 0;
			$level = $level;
			if($debug == 1){
				s1(); debug("levmulti = ".$levmulti);
			}
			$tied++;
		}
		if ($c =~ m/stunned/) {
			s1(); lost("You lost at level ".$level);
			s1(); general("Waiting 5 seconds before continuing");
			$won = 0;
			$level = $level;
			if($debug == 1){
				s1(); debug("levmulti = ".$levmulti);
			}
			sleep(6);
			$lost++;
		}
		if($b =~ m/jail time .*?!<br>/){my $jailing = $1; 
			$jailing =~ s/jail time //g;
			$jailing =~ s/!<br>//g;
			s4(); warnformat($1);nl();
			s4(); general("Please wait for the jail time to end.");nl();
			sleep($jailing);
			$parsed = 0;
		}
	}

	nl();s1(); general("Advanced CPM level test starting at level ".$level); nl();

	if($debug == 1){
		s1(); debug("base level is ".$level);
	}
	
	until ($setlev == 1){
		$reps = 0;
		$won = 0;
		$tied = 0;
		$lost = 0;
		sleep($loopwait);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
		$a = $mech->content();
				
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			until($a =~ m/Skeleton/){
				$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
				$a = $mech->content();
				s1(); infoformat("still logged out, trying again.");
				sleep($stime);
			}
		}
		
		$mech->form_number(2);
		$mech->field("Difficulty", $level);
		$mech->click_button(value => "Level");
		$a = $mech->content();
								
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto CpmlevelTop;
		}

		$cpm = $a;
		$cpm =~ m/(<option>208.*<\/option><option>209)/;
		$cpm = $1;
		$cpm =~ s/<\/option><option>209//g;
		$cpm =~ s/<option>//;
		
		if($debug == 1){
			s1(); debug("cpm = ".$cpm);
		}

		$a =~ m/(<select name="Monster">.*<\/form><form method=post>)/s;
		$a = $1;
		$b = $mech->content();	

		if ($b =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto CpmlevelTop;	
		}

		$b =~ m/(<td valign=top>Level.*<form method=post)/s;
		$b = $1;

			$filename = $namefix."-cpmINFO3.txt";
			if($debug == 1){
				open(FILE, ">>".$filename)
				or die "failed to open file!!!!";		
				print FILE "\nTHIS IS A\nTHIS IS A\n";
				print FILE $a;
				print FILE "\nTHIS IS B\nTHIS IS B\n";
				print FILE $b;
				print FILE "\n";
				close(FILE);
			}elsif($debug != 1){
				if(-e $filename){
					unlink($filename)or die "Can't delete $filename: $!\n";
					$filename = "";
				}else{
					$filename = "";
				}
			}else{
				warnformat("error in debug.");
			}

		sleep($loopwait); 
		$mech->select("Monster", $cpm);
		$mech->click_button(value => $fmodeval);
		$c = $mech->content();
								
		if ($c =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto CpmlevelTop;
		}

		$c =~ m/(<tr><td>Level : .*.<\/font><\/body><\/html>)/s;
		$c = $1;

		if ($c =~ m/You win/) {
			$won++;
			$reps++; 
			$died = 0;
			s1(); won("Test fight ".$reps." You won at level ".$level)
		}
		if ($c =~ m/battle tied/) {
			$tied++;
			$reps++;
			$died = 0;
			s1(); draw("Test fight ".$reps." You tied at level ".$level);
		}
		if ($c =~ m/stunned/) {
			$lost++;
			$reps++;
			$died = 1;
			s1(); lost("Test fight ".$reps." You lost at level ".$level);
			s1(); general("Waiting 5 seconds before continuing");
			sleep(6);
		}		
		if($b =~ m/jail time .*?!<br>/){my $jailing = $1; 
			$jailing =~ s/jail time //g;
			$jailing =~ s/!<br>//g;
			s4(); warnformat($1);nl();
			s4(); general("Please wait for the jail time to end.");nl();
			sleep($jailing);
			$parsed = 0;
		}
		
		until($reps == 10){
			CpmlevelReps:
			if($died == 1){
				last();
			}else{
				$died = 0;
			}
			sleep($loopwait); 
			$mech->reload();
			$a = $mech->content();
										
			if ($a =~ m/logged/) {
				s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
				sleep(2);
				my $relogin_thread = threads->create(\&login);
				$relogin_thread->join();
				goto CpmlevelReps;		
			}

			$b = $a;

			$filename = $namefix."-cpmINFO3.txt";
			if($debug == 1){
				open(FILE, ">>".$filename)
				or die "failed to open file!!!!";		
				print FILE "\nTHIS IS A\nTHIS IS A\n";
				print FILE $a;
				print FILE "\nTHIS IS B\nTHIS IS B\n";
				print FILE $b;
				print FILE "\n";
				close(FILE);
			}elsif($debug != 1){
				if(-e $filename){
					unlink($filename)or die "Can't delete $filename: $!\n";
					$filename = "";
				}else{
					$filename = "";
				}
			}else{
				warnformat("error in debug.");
			}

			if ($b =~ m/You win/) {
				$won++;
				$reps++;
				s1(); won("Test fight ".$reps." You won at level ".$level);
			}
			if ($b =~ m/battle tied/) {
				$tied++;
				$reps++;
				s1(); draw("Test fight ".$reps." You tied at level ".$level);
				if($tied >= 3){$tietrig = 1; $eighttwice = 0; last;}
			}
			if ($b =~ m/stunned/) {
				$lost++;
				$reps++;
				$eighttwice = 0;
				s1(); lost("Test fight ".$reps." You lost at level ".$level);
				s1(); general("Waiting 5 seconds before continuing");
				sleep(6);
				last;
			}
			if($b =~ m/jail time .*?!<br>/){my $jailing = $1; 
				$jailing =~ s/jail time //g;
				$jailing =~ s/!<br>//g;
				s4(); warnformat($1);nl();
				s4(); general("Please wait for the jail time to end.");nl();
				sleep($jailing);
				$parsed = 0;
			}
		}

		nl(); 
		@outcomes = ($won, $tied, $lost);
		my $i = 0;
		foreach(@outcomes) {
			if($i == 0){s1(); general("Won    "."$_");}elsif($i == 1){s1(); general("Tied   "."$_");}else{s1(); general("Lost   "."$_");}
			$i++;
		}
		nl(); 

		if($tietrig !=1){
			if($outcomes[0] >=8){ 
				s1(); general("Won 8 or more times."); nl();
				$newlevel = $level;
				$eighttwice++;
				if($eighttwice == 2){
					$setlev = 1;
					$eighttwice = 0;
					s1(); general("Level ".$newlevel." is set."); nl();
				}elsif($eighttwice == 1){
					s1(); general("Trying again at level ".$newlevel." for accuracy."); nl();
				}
			}elsif($outcomes[0] <=7 ){
				if($outcomes[2] >= 1){
					s1(); general("Lost a fight."); nl();
					if($debug == 1){
						s1(); debug("level = ".$level);
					}
					my $div10 = Math::BigFloat->new($level);
					$div10->bdiv(10);
					if($debug == 1){
						s1(); debug("div10 = ".$div10);
					}
					$div10->bfround(1);
					if($debug == 1){
						s1(); debug("rounded div10 = ".$div10);
					}
					$newlevel = $level - $div10;
					s1(); general("Trying level ".$newlevel); nl();
				}else{
					s1(); general("Won fewer than 8 times out of 10."); nl();
					if($debug == 1){
						s1(); debug("level = ".$level);
					}
					my $div10 = Math::BigFloat->new($level);
					$div10->bdiv(10);
					if($debug == 1){
						s1(); debug("div10 = ".$div10);
					}
					$div10->bfround(1);
					if($debug == 1){
						s1(); debug("rounded div10 = ".$div10);
					}
					$newlevel = $level - $div10;
					s1(); general("Trying level ".$newlevel); nl();
				}
			}else{
				s1(); general("Wins error. Something is wrong\n");
			}
		}else{
			if($debug == 1){
				s1(); debug("TIETRIG TRIGGERED");nl();
				s1(); debug("level = ".$level);
			}
			s1(); general("Tied more than twice.");nl();
			my $div10 = Math::BigFloat->new($level);
			$div10->bdiv(5);
			if($debug == 1){
				s1(); debug("div10 = ".$div10);
			}
			$div10->bfround(1);
			if($debug == 1){
				s1(); debug("rounded div10 = ".$div10);
			}
			$newlevel = $level - $div10;
			s1(); general("Trying level ".$newlevel); nl();
			$tietrig = 0;
		}
		if($debug == 1){
			s1(); debug("Trying level ".$newlevel); nl();	
		}
		$level = $newlevel;
	}

	if($setlev == 1){
		if($debug == 1){
			s1(); debug("Trying level ".$newlevel); nl();
		}
		open(FILE, "+>".$fname)
		or die "failed to open file!!!!";
		print FILE "$newlevel";
		close(FILE);
		if($debug == 1){
			s1(); debug("filelevel updated sucessfully");
		}
		$setlev = 0;
	}
	return($newlevel);
}

sub Fight {
	FightTop:
	$parsed = 0;
	while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
		$a = $mech->content();	

		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
		}

		if($a =~ m/Skeleton/){
			$parsed = 1;
		}
		$aa = $a;
		if($aa =~ m/(Stun time .*!<br>Please)/){
			$aa = $1;
			$aa =~ s/<br>Please//g;			
			s4(); warnformat($aa);nl();
			$aa =~ s/Stun time //g;
			$aa =~ s/!//g;
			$aa = $aa + 2;
			s4(); general("Please wait for the stun time to end.");nl();
			sleep($aa);
			$parsed = 0;
		}
	}

	$filename = $namefix."-Fight.txt";
	if($debug == 1){
		open(FILE, ">>".$filename)
		or die "failed to open file!!!!";
		print FILE "Fight\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		s1(); debug("Fight");
	}elsif($debug != 1){
		if(-e $filename){
			unlink($filename)or die "Can't delete $filename: $!\n";
			$filename = "";
		}else{
			$filename = "";
		}
	}else{
		warnformat("error in debug.");
	}
	
	$mech->form_number(2);
	$mech->field("Difficulty", $level);
	$mech->click();
	$cpm = $mech->content();
	
	if ($cpm =~ m/logged/) {
		s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
		sleep(2);
		my $relogin_thread = threads->create(\&login);
		$relogin_thread->join();
		goto FightTop;
	}

	$filename = $namefix."-Fightlevel.txt";
	if($debug == 1){
		open(FILE, ">>".$filename)
		or die "failed to open file!!!!";
		print FILE "Fightlevel\n\n";
		print FILE "$cpm\n\n";
		close(FILE);
		s1(); debug("Fightlevel");
	}elsif($debug != 1){
		if(-e $filename){
			unlink($filename)or die "Can't delete $filename: $!\n";
			$filename = "";
		}else{
			$filename = "";
		}
	}else{
		warnformat("error in debug.");
	}

	$cpm =~ m/(<option>208.*<\/option><option>209)/;
    $cpm = $1;
    $cpm =~ s/ - Shadowlord Duke//g;
    $cpm =~ s/\>209/\>/;
    $cpm =~ s/<.*?>//g;
	s1(); general($cpm); 
	$mech->form_number(1);
	$mech->select("Monster", $cpm);
	$mech->click_button(value => $fmodeval);
	$a = $mech->content();

	if ($a =~ m/logged/) {
		s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
		sleep(2);
		my $relogin_thread = threads->create(\&login);
		$relogin_thread->join();
		goto FightTop;
	}


	$filename = $namefix."-Fight2.txt";
	if($debug == 1){
		open(FILE, ">>".$filename)
		or die "failed to open file!!!!";
		print FILE "Fight2\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		s1(); debug("Fight2");
	}elsif($debug != 1){
		if(-e $filename){
			unlink($filename)or die "Can't delete $filename: $!\n";
			$filename = "";
		}else{
			$filename = "";
		}
	}else{
		warnformat("error in debug.");
	}

	$ant = 1800;
	$ant1 = new Math::BigFloat $ant;
	my$divided = new Math::BigFloat $loopwait;
	if ($loopwait <= 0.3){$divided = 0.4;}
	if ($loopwait >= 1.0){$divided = 0.9;}
	$divided = $divided*100;
	$divided = $divided/90;
	$ant1->bdiv($divided);
	$ant1->bstr();
	$ant1->bfround(1);
	$antal = $ant1;
	if($antal >= 3600){
	   $antal = 3600;
	} 

	#REPEAT:
	while($antal > 0) {
		FightAntal:
		sleep($loopwait);
		$antal = $antal -1;
		my $retries = 0;
		retry:
		$mech->reload();
		$a = $mech->content();
		
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto FightAntal;
		}

		$filename = $namefix."-Fight3.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "Fight3\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);
			
			s1(); debug("Fight3");
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		$b = $a;
		$c = $a;
		$d = $mech->status();
		if($d == 500 or $d == 400){
			if($retries == 0){
				if($d == 400){
					s1(); errorformat("more 400 error's");
				}else{
					s1(); errorformat("Trouble Connecting to internet....Probably.");
				}
			}
			until ($d == 200){
				$retries = $retries +1;
				if($retries == 5){
					goto RETRY;
				}
				sleep($stime);
				goto retry;
			}
		}
	
	#KILLED
		if($a =~ m/(been.*slain)/) {
			s1();  lost( "You were slain!");
		}
		
	#LOGGED OUT

		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
		}
		if ($antal <= 0) {
			sleep(3);
			s1(); infoformat("Waiting last few seconds before restarting");
			goto START;
		}
		if ($b =~ m/(400 Bad Request)/) {s1(); errorformat("400 error restarting.");
			goto START;
		}
		
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		$output = "Output was not set";
		if($b =~ m/(You win .*? exp)/){$output = $1;
		$happened = 1;}
		if($b =~ m/(The battle tied)/){$output = $1;$happened = 2;}
		if($b =~ m/(jail time .*?!<br>)/){
			$c = $1;
			$c =~ s/<br>//g;
			$c =~ s/jail/Stun/g;
			$output = $c;
			$happened = 3;
		}
		if($b =~ m/logged/){$output = "You were logged back in.";$happened = 4;}
		if($b =~ m/(Stun time .*?!<br>Please)/){
			$c = $1;
			$c =~ s/<br>Please//g;
			$output = $c;
			$happened = 5;
		}
		if($b =~ m/(stunned for .* seconds.)/){
			$output = $1;
			$happened = 6;
		}

		if($happened == 1){
			s1(); won("$antal: [$Hour:$Minute:$Second]: " . $output);
			$happened = 0;
		}elsif($happened == 2){
			s1(); draw("$antal: [$Hour:$Minute:$Second]: " . $output);
			$happened = 0;
		}elsif($happened == 3){
			s1(); warnformat("$antal: [$Hour:$Minute:$Second]: " . $output);
			$happened = 0;
		}elsif($happened == 4){
			s1(); warnformat("$antal: [$Hour:$Minute:$Second]: " . $output);
			$happened = 0;
		}elsif($happened == 5){
			s1(); warnformat("$antal: [$Hour:$Minute:$Second]: " . $output);
			$happened = 0;
		}elsif($happened == 6){
			s1(); warnformat("$antal: [$Hour:$Minute:$Second]: " . $output);
			$happened = 0;
		}else{
			s1(); errorformat($antal.":"."[".$Hour.":".$Minute.":".$Second."] : Something isn't right with output in lowfight");
		}

		if (($b =~ m/(Level up.*HERE!)/) and ($indefcont != 1)) {
			if($persist == 100){
				$persist = 0;
				&Levelup;
			}else{
				$persist++;
				if($debug == 1){
					s1(); debug("Skipping levelup 100 times. persist = ".$persist);
				}
			}
		}
	}
}

sub Levelup{
	if($debug == 1){
		s1(); debug("Arrived at Levelup");
	}

		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."stats.php");
		$a = $mech->content();
		if($a =~ m/<a href="stats.php/){
			sleep($stime);
			$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."stats.php");
			$a = $mech->content();
		}
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			until($a =~ m/Natural Stats/){
				$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."stats.php");
				$a = $mech->content();
				s1(); infoformat("still logged out, trying again.");
				sleep($stime);
			}
		}

		$filename = $namefix."-Levelup.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "Levelup\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);
			
			s1(); debug("Levelup");
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}


		$b = $a;
		$a =~ m/(You have .* levels available)/;
		my $numlevs = $1;
		$numlevs =~ s/You have //s;
		$numlevs =~ s/ levels available//s;
		$numlevs =~ s/,//gs;
		
		#chartype 13 and 14 level up
		$ratiolevs = new Math::BigFloat $numlevs;
		$ratiolevs = $ratiolevs/100;
		
		my $ActualLevel = $MyLev;
		$b =~ m/(Level : .*Exp :)/;
		$b = $1;
		my $accclev = $b;
		$b =~ s/.<\/td> .*//si;
		$b =~ s/Level : //si;
		$ActualLevel = $b;
		$accclev =~ s/,//sig;
		$accclev =~ m/(\d+)/;
		$accclev = $1;
		if ($accclev < $maxlev){
			if($numlevs+$accclev >= $maxlev){
				$numlevs = $maxlev-$accclev;
			}
			my $numlevs1 = $numlevs;
			while($numlevs1 =~ m/([0-9]{4})/){
				my $temp1 = reverse $numlevs1;
				$temp1 =~ s/(?<=(\d\d\d))(?=(\d))/,/;
				$numlevs1 = reverse $temp1;
			}
			
			#for chartype 13 and 14
			$strlevs = new Math::BigFloat $strlevs;
			$strlevs = $ratiolevs*$ratio0;
			$dexlevs = new Math::BigFloat $dexlevs;
			$dexlevs = $ratiolevs*$ratio1;
			$agillevs = new Math::BigFloat $agillevs;
			$agillevs = $ratiolevs*$ratio2;
			$intlevs = new Math::BigFloat $intlevs;
			$intlevs = $ratiolevs*$ratio3;
			$conclevs = new Math::BigFloat $conclevs;
			$conclevs = $ratiolevs*$ratio4;
			$contralevs = new Math::BigFloat $contralevs;
			$contralevs = $ratiolevs*$ratio5;
			if($strlevs > 0 && $strlevs < 1){$strlevs = 1;}else{$strlevs->bfround(1);}
			if($dexlevs > 0 && $dexlevs < 1){$dexlevs = 1;}else{$dexlevs->bfround(1);}
			if($agillevs > 0 && $agillevs < 1){$agillevs = 1;}else{$agillevs->bfround(1);}
			if($intlevs > 0 && $intlevs < 1){$intlevs = 1;}else{$intlevs->bfround(1);}
			if($conclevs > 0 && $conclevs < 1){$conclevs = 1;}else{$conclevs->bfround(1);}
			if($contralevs > 0 && $contralevs < 1){$contralevs = 1;}else{$contralevs->bfround(1);}

			sleep($stime);
			if($chartype ==1){
				if(($aslevel <= $deflevel) && ($aslevel <= $mrlevel)) {
					$mech->form_number(1);
					$mech->field("Intelligence", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("You Leveled "."$numlevs1"." Intelligence");
					&CheckShop;
				}
				if(($deflevel <= $aslevel) && ($deflevel <= $mrlevel)) {
					$mech->form_number(1);
					$mech->field("Agility", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("You Leveled "."$numlevs1"." Agility");
				}

				if(($mrlevel <= $deflevel) && ($mrlevel <= $aslevel)) {
					$mech->form_number(1);
					$mech->field("Concentration", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("You Leveled "."$numlevs1"." Concentration");
				}
			}elsif($chartype == 2){
				if(($wdlevel <= $mrlevel) && ($wdlevel <= $arlevel)) {
					$mech->form_number(1);
					$mech->field("Strength", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("You Leveled "."$numlevs1"." Strength");
					&CheckShop;
				}
				if(($arlevel <= $wdlevel) && ($arlevel <= $mrlevel)) {
					$mech->form_number(1);
					$mech->field("Dexterity", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("You Leveled "."$numlevs1"." Dexterity");
				}

				if(($mrlevel <= $wdlevel) && ($mrlevel <= $arlevel)) {
					$mech->form_number(1);
					$mech->field("Concentration", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("You Leveled "."$numlevs1"." Concentration");
				}
			}elsif($chartype == 3){
				if(($aslevel <= $arlevel) && ($aslevel <= $mrlevel)) {
					$mech->form_number(1);
					$mech->field("Intelligence", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("Leveled up "."$numlevs1"." Intelligence");
					&CheckShop;
				}
				if(($arlevel <= $aslevel) && ($arlevel <= $mrlevel)) {
					$mech->form_number(1);
					$mech->field("Dexterity", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("Leveled up "."$numlevs1"." Dexterity");
				}

				if(($mrlevel <= $arlevel) && ($mrlevel <= $aslevel)) {
					$mech->form_number(1);
					$mech->field("Concentration", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("Leveled up "."$numlevs1"." Concentration");
				}
			}elsif($chartype == 4){
				if($wdlevel <= $arlevel) {
				$mech->form_number(1);
				$mech->field("Strength", $numlevs);
				$mech->click_button('value' => 'Level Up!!!');
				s1(); general("Leveled up "."$numlevs1"." Strength");
				&CheckShop;
				}		
				if($arlevel <= $wdlevel) {
					$mech->form_number(1);
					$mech->field("Dexterity", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("Leveled up "."$numlevs1"." Dexterity");
				}
			}elsif($chartype == 5){
				if($mrlevel >= $aslevel) {
					$mech->form_number(1);	
					$mech->field("Intelligence", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("Leveled up "."$numlevs1"." Intelligence");
					&CheckShop;
				}

				if($aslevel >= $mrlevel) {
					$mech->form_number(1);
					$mech->field("Concentration", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("Leveled up "."$numlevs1"." Concentration");
				}
			}elsif($chartype == 6){
				if(($wdlevel <= $mslevel) && ($wdlevel <= $arlevel)) {
					$mech->form_number(1);
					$mech->field("Strength", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("Leveled up "."$numlevs1"." Strength");
					&CheckShop;
				}
				if(($mslevel <= $wdlevel) && ($mslevel <= $arlevel)) {
					$mech->form_number(1);
					$mech->field("Contravention", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("Leveled up "."$numlevs1"." Contravention");
				}
				if(($arlevel <= $mslevel) && ($arlevel <= $wdlevel)) {
					$mech->form_number(1);
					$mech->field("Dexterity", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					s1(); general("Leveled up "."$numlevs1"." Dexterity");
				}
			}elsif($chartype == 13 or $chartype == 14){
				if($numlevs>6){
					$mech->form_number(1);
					$mech->field("Strength", $strlevs);
					s1(); general("Leveled up "."$strlevs"." Strength");
					$mech->field("Dexterity", $dexlevs);
					s1(); general("Leveled up "."$dexlevs"." Dexterity");
					$mech->field("Agility", $agillevs);
					s1(); general("Leveled up "."$agillevs"." Agility");
					$mech->field("Intelligence", $intlevs);
					s1(); general("Leveled up "."$intlevs"." Intelligence");
					$mech->field("Concentration", $conclevs);
					s1(); general("Leveled up "."$conclevs"." Concentration");
					$mech->field("Contravention", $contralevs);
					s1(); general("Leveled up "."$contralevs"." Contravention");
					$mech->click_button('value' => 'Level Up!!!');
					&CheckShop;
				}else{
					s1(); general("Skipping levelup because there are less than 6 levels to level.");
					goto START;

				}
			}
		}else{
			s1(); general("Did not level, Max level reached.");
			$indefcont = 1;
		}
	goto START;
}

sub CheckShop{
		$parsed = 0; 
	while (!$parsed){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."shop.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
		}
		$aa = $a;
		if($aa =~ m/(Stun time .*!<br>Please)/){
			$aa = $1;
			$aa =~ s/<br>Please//g;			
			s4(); warnformat($aa);nl();
			$aa =~ s/Stun time //g;
			$aa =~ s/!//g;
			$aa = $aa + 2;
			s4(); general("Please wait for the stun time to end.");nl();
			sleep($aa);
			$parsed = 0;
		}
	}

	$filename = $namefix."-CheckShop.txt";
	if($debug == 1){
		open(FILE, ">>".$filename)
		or die "failed to open file!!!!";
		print FILE "Checkshop\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);	
		s1(); debug("Checkshop"); nl();
	}elsif($debug != 1){
		if(-e $filename){
			unlink($filename)or die "Can't delete $filename: $!\n";
			$filename = "";
		}else{
			$filename = "";
		}
	}else{
		warnformat("error in debug.");
	}

	if($shopyesno == 1){
		&MaxShops;
	}else{
		s1(); general("Shops were not bought this time");nl();
	}
}

sub MaxShops{
	MaxShopsTop:
	$parsed = 0; 
	while (!$parsed){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."shop.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
		}
		$aa = $a;
		if($aa =~ m/(Stun time .*!<br>Please)/){
			$aa = $1;
			$aa =~ s/<br>Please//g;			
			s4(); warnformat($aa);nl();
			$aa =~ s/Stun time //g;
			$aa =~ s/!//g;
			$aa = $aa + 2;
			s4(); general("Please wait for the stun time to end.");nl();
			sleep($aa);
			$parsed = 0;
		}
	}

	$filename = $namefix."-MaxShops.txt";
	if($debug == 1){
		open(FILE, ">>".$filename)
		or die "failed to open file!!!!";
		print FILE "MaxShops\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		s1(); debug("MaxShops"); nl();
		
	}elsif($debug != 1){
		if(-e $filename){
			unlink($filename)or die "Can't delete $filename: $!\n";
			$filename = "";
		}else{
			$filename = "";
		}
	}else{
		warnformat("error in debug.");
	}
	
	my $shop1 = $a;
	my $shop2 = $a;
	my $shop3 = $a;
	my $shop4 = $a;
	my $shop5 = $a;
	my $shop6 = $a;
	my $shop7 = $a;
	my $shop8 = $a;
	my $shop9 = $a;
	my $shop10 = $a;
	my $shop11 = $a;
	my $shop12 = $a;
	
	$shop1 =~ m/(Weapon.*?<\/form>)/s;
	$shop1 = $1;
	$shop2 =~ m/(Attackspell.*?<\/form>)/s;
	$shop2 = $1;
	$shop3 =~ m/(Healspell.*?<\/form>)/s;
	$shop3 = $1;
	$shop4 =~ m/(Helmet.*?<\/form>)/s;
	$shop4 = $1;
	$shop5 =~ m/(Shield.*?<\/form>)/s;
	$shop5 = $1;
	$shop6 =~ m/(Amulet.*?<\/form>)/s;
	$shop6 = $1;
	$shop7 =~ m/(Ring.*?<\/form>)/s;
	$shop7 = $1;
	$shop8 =~ m/(Armor.*?<\/form>)/s;
	$shop8 = $1;
	$shop9 =~ m/(Belt.*?<\/form>)/s;
	$shop9 = $1;
	$shop10 =~ m/(Pants.*?<\/form>)/s;
	$shop10 = $1;
	$shop11 =~ m/(Hand.*?<\/form>)/s;
	$shop11 = $1;
	$shop12 =~ m/(Feet.*?<\/form>)/s;
	$shop12 = $1;
	#healspell sub call &MaxHS(\$shop3);

	if($chartype == 1){
		&MaxAS(\$shop2);
		&MaxHE(\$shop4);
		&MaxSH(\$shop5);
		&MaxAM(\$shop6);
		&MaxRI(\$shop7);
		&MaxAR(\$shop8);
		&MaxBE(\$shop9);
		&MaxPA(\$shop10);
		&MaxHA(\$shop11);
		&MaxFE(\$shop12);
	}elsif($chartype == 2){
		&MaxWD(\$shop1);
		&MaxBE(\$shop9);
		&MaxHA(\$shop11);
		&MaxFE(\$shop12);
	}elsif($chartype == 3){
		&MaxAS(\$shop2);
		&MaxRI(\$shop7);
		&MaxBE(\$shop9);
		&MaxFE(\$shop12);
	}elsif($chartype == 4){
		&MaxWD(\$shop1);
		&MaxHA(\$shop11);
		&MaxFE(\$shop12);
	}elsif($chartype == 5){
		&MaxAS(\$shop2);
		&MaxRI(\$shop7);
		&MaxBE(\$shop9);
	}elsif($chartype == 6){
		&MaxWD(\$shop1);
		&MaxAM(\$shop6);
		&MaxRI(\$shop7);
		&MaxHA(\$shop11);
		&MaxFE(\$shop12);
	}elsif($chartype == 13 or $chartype == 14){
		&MaxWD(\$shop1);
		&MaxAS(\$shop2);
		&MaxHS(\$shop3);
		&MaxHE(\$shop4);
		&MaxSH(\$shop5);
		&MaxAM(\$shop6);
		&MaxRI(\$shop7);
		&MaxAR(\$shop8);
		&MaxBE(\$shop9);
		&MaxPA(\$shop10);
		&MaxHA(\$shop11);
		&MaxFE(\$shop12);
	}
	#goto GOTO;
}

sub MaxWD{	
	$Sname = "Weapon";
    my ($shop1) = @_;
	if($$shop1 =~ "Maxed"){$proceed = 0;s1(); general($Sname." Maxed");}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(1);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
		
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto MaxShopsTop;
		}

		$b = $a;			
		$filename = $namefix."-MaxWD.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "MaxWD\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			s1(); debug("MaxWD"); nl();
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		if ($a =~ m/Not enough gold!/){
			s1(); general("You did not have enough Gold in your hand to max all your shops."); 
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			s1(); general("$a");
		}
		$b =~ m/(<td>Weapon<\/td>.*?<\/form>)/s;
		$b = $1;
		if($b =~ "Maxed"){$proceed = 0; s1(); general($Sname." shops Maxed.");}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxAS{
	$Sname = "Attackspell";
    my ($shop2) = @_;
	if($$shop2 =~ "Maxed"){$proceed = 0;s1(); general($Sname." Maxed");}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(2);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
				
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto MaxShopsTop;
		}

		$b = $a;

		$filename = $namefix."-MaxAS.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "MaxAS\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);
			s1(); debug("MaxAS"); nl();
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		if ($a =~ m/Not enough gold!/){
			s1(); general("You did not have enough Gold in your hand to max all your shops.");
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			s1(); general("$a");
		}
		$b =~ m/(<td>Attackspell<\/td>.*?<\/form>)/s;
		$b = $1;
		if($b =~ "Maxed"){$proceed = 0; s1(); general($Sname." shops Maxed.");}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxHS{
	$Sname = "Healspell";
    my ($shop3) = @_;
	if($$shop3 =~ "Maxed"){$proceed = 0;s1(); general($Sname." Maxed");}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(3);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
				
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto MaxShopsTop;
		}

		$b = $a;

		$filename = $namefix."-MaxHS.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "MaxHS\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);
			
			s1(); debug("MaxHS"); nl();
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		if ($a =~ m/Not enough gold!/){
			s1(); general("You did not have enough Gold in your hand to max all your shops.");
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			s1(); general("$a");
		}
		$b =~ m/(<td>Healspell<\/td>.*?<\/form>)/s;
		$b = $1;
		if($b =~ "Maxed"){$proceed = 0; s1(); general($Sname." shops Maxed.");}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxHE{
	$Sname = "Helmet";
    my ($shop4) = @_;
	if($$shop4 =~ "Maxed"){$proceed = 0;s1(); general($Sname." Maxed");}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(4);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
				
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto MaxShopsTop;
		}

		$b = $a;		

		$filename = $namefix."-MaxHE.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "MaxHE\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);
			s1(); debug("MaxHE"); nl();
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}	
		if ($a =~ m/Not enough gold!/){
			s1(); general("You did not have enough Gold in your hand to max all your shops.");
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			s1(); general("$a");
		}
		$b =~ m/(<td>Helmet<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; s1(); general($Sname." shops Maxed.");}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxSH{
	$Sname = "Shield";
    my ($shop5) = @_;
	if($$shop5 =~ "Maxed"){$proceed = 0;s1(); general($Sname." Maxed");}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(5);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();	

		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto MaxShopsTop;
		}

		$b = $a;

		$filename = $namefix."-MaxSH.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "MaxSH\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			s1(); debug("MaxSH"); nl();
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		if ($a =~ m/Not enough gold!/){
			s1(); general("You did not have enough Gold in your hand to max all your shops.");
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			s1(); general("$a");
		}
		$b =~ m/(<td>Shield<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; s1(); general($Sname." shops Maxed.");}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxAM{		
	$Sname = "Amulet";
    my ($shop6) = @_;	
	if($$shop6 =~ "Maxed"){$proceed = 0;s1(); general($Sname." Maxed");}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(6);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
				
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto MaxShopsTop;
		}

		$b = $a;		

		$filename = $namefix."-MaxAM.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "MaxAM\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			s1(); debug("MaxAM"); nl();
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}	

		if ($a =~ m/Not enough gold!/){
			s1(); general("You did not have enough Gold in your hand to max all your shops.");
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			s1(); general("$a");
		}
		$b =~ m/(<td>Amulet<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; s1(); general($Sname." shops Maxed.");}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxRI{
	$Sname = "Ring";
    my ($shop7) = @_;
	if($$shop7 =~ "Maxed"){$proceed = 0;s1(); general($Sname." Maxed");}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(7);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
				
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto MaxShopsTop;
		}

		$b = $a;		
		
		$filename = $namefix."-MaxRI.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "MaxRI\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			s1(); debug("MaxRI"); nl();
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		if ($a =~ m/Not enough gold!/){
			s1(); general("You did not have enough Gold in your hand to max all your shops.");
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			s1(); general("$a");
		}
		$b =~ m/(<td>Ring<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; s1(); general($Sname." shops Maxed.");}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxAR{
	$Sname = "Armor";
    my ($shop8) = @_;
	if($$shop8 =~ "Maxed"){$proceed = 0;s1(); general($Sname." Maxed");}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(8);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
				
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto MaxShopsTop;
		}

		$b = $a;	

		$filename = $namefix."-MaxAR.txt";	
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "MaxAR\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			s1(); debug("MaxAR"); nl();
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		if ($a =~ m/Not enough gold!/){
			s1(); general("You did not have enough Gold in your hand to max all your shops.");
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			s1(); general("$a");
		}
		$b =~ m/(<td>Armor<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; s1(); general($Sname." shops Maxed.");}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxBE{
	$Sname = "Belt";
	my ($shop9) = @_;
	if($$shop9 =~ "Maxed"){$proceed = 0;s1(); general($Sname." Maxed");}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(9);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
				
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto MaxShopsTop;
		}

		$b = $a;

		$filename = $namefix."-MaxBE.txt";		
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "MaxBE\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			s1(); debug("MaxBE"); nl();
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		if ($a =~ m/Not enough gold!/){
			s1(); general("You did not have enough Gold in your hand to max all your shops.");
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			s1(); general("$a");
		}
		$b =~ m/(<td>Belt<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; s1(); general($Sname." shops Maxed.");}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxPA{
	$Sname = "Pants";
    my ($shop10) = @_;
	if($$shop10 =~ "Maxed"){$proceed = 0;s1(); general($Sname." Maxed");}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(10);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
				
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto MaxShopsTop;
		}

		$b = $a;

		$filename = $namefix."-MaxPA.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "MaxPA\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			s1(); debug("MaxPA"); nl();
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		if ($a =~ m/Not enough gold!/){
			s1(); general("You did not have enough Gold in your hand to max all your shops.");
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			s1(); general("$a");
		}
		$b =~ m/(<td>Pants<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; s1(); general($Sname." shops Maxed.");}
	}	
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxHA{
	$Sname = "Hand";
    my ($shop11) = @_;
	if($$shop11 =~ "Maxed"){$proceed = 0;s1(); general($Sname." Maxed");}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(11);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
				
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto MaxShopsTop;
		}

		$b = $a;

		$filename = $namefix."-MaxHA.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "MaxHA\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			s1(); debug("MaxHA"); nl();
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		if ($a =~ m/Not enough gold!/){
			s1(); general("You did not have enough Gold in your hand to max all your shops.");
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			s1(); general("$a");
		}
		$b =~ m/(<td>Hand<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; s1(); general($Sname." shops Maxed.");}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxFE{	
	$Sname = "Feet";
    my ($shop12) = @_;	
	if($$shop12 =~ "Maxed"){$proceed = 0;s1(); general($Sname." Maxed");nl();}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(12);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
				
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto MaxShopsTop;
		}

		$b = $a;

		$filename = $namefix."-MaxFE.txt";
		if($debug == 1){
			open(FILE, ">>".$filename)
			or die "failed to open file!!!!";
			print FILE "MaxFE\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			s1(); debug("MaxFE"); nl();
		}elsif($debug != 1){
			if(-e $filename){
				unlink($filename)or die "Can't delete $filename: $!\n";
				$filename = "";
			}else{
				$filename = "";
			}
		}else{
			warnformat("error in debug.");
		}

		if ($a =~ m/Not enough gold!/){
			s1(); general("You did not have enough Gold in your hand to max all your shops.");nl();
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			s1(); general("$a");
		}
		$b =~ m/(<td>Feet<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; s1(); general($Sname." shops Maxed.");nl();}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub Charname{
	CharnameTop:
	sleep(0.5);
	$parsed = 0; 
	while (!$parsed){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."stats.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
		}
		$aa = $a;
		if($aa =~ m/(Stun time .*!<br>Please)/){
			$aa = $1;
			$aa =~ s/<br>Please//g;			
			s4(); warnformat($aa);nl();
			$aa =~ s/Stun time //g;
			$aa =~ s/!//g;
			$aa = $aa + 2;
			s4(); general("Please wait for the stun time to end.");nl();
			sleep($aa);
			$parsed = 0;
		}
	}

	$filename = $username."-Charname.txt";
	if($debug == 1){
		open(FILE, ">>".$filename)
		or die "failed to open file!!!!";
		print FILE "Charname\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		nl(); s1(); debug("Charname");
	}elsif($debug != 1){
		if(-e $filename){
			unlink($filename)or die "Can't delete $filename: $!\n";
			$filename = "";
		}else{
			$filename = "";
		}
	}else{
		warnformat("error in debug.");
	}

	$a = $mech->content();
			
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto CharnameTop;
		}

	$b = $a;
	$c = $a;
	
	if($a =~m/(You have .* levels)/){
		$avlevs = $a;
		$avlevs =~ m/(You have .* levels available)/;
		$avlevs = $1;
		$avlevs =~ s/You have //s;
		$avlevs =~ s/ levels available//s;
		$avlevs =~ s/,//gs;
	}
	
	$a =~ s/(.*)(natural)//si; #remove before
	$a =~ s/<\/th.*//si; #remove after
	$a =~ s/(.*)(for)//si; #remove before
	$charname = $a;
	$charname =~ m/(\w+)\s+(\w+)/;
	$title = $1;
	$name = $2;
	$title =~ s/ //sgi;
	$name =~ s/ //sgi;	
	#$namefix = $title." ".$name;
	#files without titles because titles can change
	$namefix = $name;
	nl(); s1(); general("Successfully logged into $title $name at $Hour:$Minute:$Second");nl();

	$b =~ m/(You need.*exp )/;
	$b = $1;
	$b =~ s/you//i;
	$b =~ s/need//i;
	$b =~ s/exp//i;
	$b =~ s/,//gi;
	$b =~ s/\s//gi;
	$Nextlevel = new Math::BigFloat $b;
		
	$c =~ s/(.*)(secondary)//si; #remove before
	$c =~ s/(.*)(Min)//si; #remove before
	$c =~ s/top>Max.*//si; #remove after
	$c =~ s/\.//gi;
	$c =~ s/<hr>/a/i;
	$c =~ s/<br>/b/i;
	$c =~ s/<br>/c/i;
	$c =~ s/<br>/d/i;
	$c =~ s/<br>/e/i;
	$c =~ s/<br>/f/i;
	$c =~ s/<br>/g/i;
	$c =~ s/<br>/h/i;
	$c =~ s/<br>/i/i;
	$c =~ s/<br>/j/i;
	$c =~ s/<\/td>/k/i;
	$c =~ s/<//i;
	$c =~ s/>//i;
	$c =~ s/\///i;
	$c =~ s/<td align=right valign=//i;
	if($debug == 1){
		s1(); debug("c =".$c);
	}
		$c =~ m/(a.*b)/;
			$c0 = $1;
				$c0 =~ s/[a-z]//ig;
				$c0= new Math::BigFloat $c0;
		if($debug == 1){
			s1(); debug("c0 =".$c0);
		}
		$c =~ m/(b.*c)/;
			$c1 = $1;
				$c1 =~ s/[a-z]//ig;
				$c1= new Math::BigFloat $c1;
		if($debug == 1){
			s1(); debug("c1 =".$c1);
		}
		$c =~ m/(c.*d)/;
			$c2 = $1;
				$c2 =~ s/[a-z]//ig;
				$c2= new Math::BigFloat $c2;
		if($debug == 1){
			s1(); debug("c2 =".$c2);
		}
		$c =~ m/(d.*e)/;
			$c3 = $1;
				$c3 =~ s/[a-z]//ig;
				$c3= new Math::BigFloat $c3;
		if($debug == 1){
			s1(); debug("c3 =".$c3);
		}
		$c =~ m/(e.*f)/;
			$c4 = $1;
				$c4 =~ s/[a-z]//ig;
				$c4= new Math::BigFloat $c4;
		if($debug == 1){
			s1(); debug("c4 =".$c4);
		}
		$c =~ m/(f.*g)/;
			$c5 = $1;
				$c5 =~ s/[a-z]//ig;
				$c5= new Math::BigFloat $c5;
		if($debug == 1){
			s1(); debug("c5 =".$c5);
		}
		$c =~ m/(g.*h)/;
			$c6 = $1;
				$c6 =~ s/[a-z]//ig;
				$c6= new Math::BigFloat $c6;
		if($debug == 1){
			s1(); debug("c6 =".$c6);
		}
		$c =~ m/(h.*i)/;
			$c7 = $1;
				$c7 =~ s/[a-z]//ig;
				$c7= new Math::BigFloat $c7;
		if($debug == 1){
			s1(); debug("c7 =".$c7);
		}
   		$c =~ m/(i.*j)/;
			$c8 = $1;
				$c8 =~ s/[a-z]//ig;
				$c8= new Math::BigFloat $c8;
		if($debug == 1){
			s1(); debug("c8 =".$c8);
		}
		$c =~ m/(j.*k)/;
			$c9 = $1;
				$c9 =~ s/[a-z]//ig;
				$c9= new Math::BigFloat $c9;
		if($debug == 1){
			s1(); debug("c9 =".$c9); nl();
		}

		#if(($c0 >= "731420819") or ($c1 >= "734691740") or ($c7 >= #"921382475")){
		#	if(($c5 >= "73506388")or($c6 >= "74836787")or($c6 >= #"144668877")){
		#		$cpmready = 1;
		#	}else{
		#		$cpmready = 0;
		#	}
		#}else{
		#	$cpmready = 0;
		#}
		
	my $addir = "AD";
	my $apdir = "AP";
	my $spdir = "SP";
	
	if($fmode == 1){		
		$levelfilename = $path."/".$addir."/".$name;
	}elsif($fmode == 2){
		$levelfilename = $path."/".$apdir."/".$name;
	}elsif($fmode == 3){
		$levelfilename = $path."/".$spdir."/".$name;
	}
	
	if($debug == 1){
		s1(); debug($levelfilename); nl();
	}elsif($debug != 1 and $firstlogin == 1){
		my @files_to_delete = ($namefix.'-cpmINFO1.txt',$namefix.'-cpmINFO2.txt',$namefix.'-cpmINFO3.txt',$namefix.'-TESTINFO1.txt',$namefix.'-TESTINFO2.txt',$namefix.'-LowFight.txt',$namefix.'-LowFight2.txt',$namefix.'-LowFight3.txt',$namefix.'-Autolevelup.txt',$namefix.'-CPMlevel.txt',$namefix.'-Fight.txt',$namefix.'-Fightlevel.txt',$namefix.'-Fight2.txt',$namefix.'-Fight3.txt',$namefix.'-Levelup.txt',$namefix.'-CheckShop.txt',$namefix.'-MaxShops.txt',$namefix.'-MaxWD.txt',$namefix.'-MaxAS.txt',$namefix.'-MaxHS.txt',$namefix.'-MaxHE.txt',$namefix.'-MaxSH.txt',$namefix.'-MaxAM.txt',$namefix.'-MaxRI.txt',$namefix.'-MaxAR.txt',$namefix.'-MaxBE.txt',$namefix.'-MaxPA.txt',$namefix.'-MaxHA.txt',$namefix.'-MaxFE.txt',$namefix.'-MyLevel.txt',$namefix.'-cpmready.txt',$username.'-Charname.txt',$username.'-Loginrecord.txt');

		#foreach my $file (@files_to_delete) {
		#	s1(); debug("Filename = ".$file);
		#}

		foreach my $file (@files_to_delete) {
			if (-e $file) {
				unlink($file) or warn "Could not delete $file: $!\n";
			}
		}
		$firsttitle = 1;
		$firstlogin = 0;
	}
	if($debug == 1 and $firstlogin == 1){ 		
		$firsttitle = 1;
		$firstlogin = 0;
	}
	
	#title updater thread
	
	sub update_title {
		my ($title, $name) = @_;

		while (1) {			
			sleep(1); 
			$seconds2++;
			my $hours2   = int($seconds2 / 3600);
			my $minutes2 = int(($seconds2 % 3600) / 60);
			my $secs2    = $seconds2 % 60;
			$timer = sprintf("%02d:%02d:%02d", $hours2, $minutes2, $secs2);
			my ($Second, $Minute, $Hour) = localtime(time);
			title("$name | $timer-$Hour:$Minute:$Second");
		}
	}

	sub title {
		my ($new_title) = @_;
		print "\033]0;$new_title\007";
		STDOUT->flush(); 
	}

	if($firsttitle == 1){
		my $title_thread = threads->create(\&update_title, $title, $name);
		$title_thread->detach();
		$firsttitle = 0;
	}
	#title updater thread
}

sub MyLevel{
	MyLevelTop:
	$parsed = 0; 
	while (!$parsed){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."main.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
		}
		$aa = $a;
		if($aa =~ m/(Stun time .*!<br>Please)/){
			$aa = $1;
			$aa =~ s/<br>Please//g;			
			s4(); warnformat($aa);nl();
			$aa =~ s/Stun time //g;
			$aa =~ s/!//g;
			$aa = $aa + 2;
			s4(); general("Please wait for the stun time to end.");nl();
			sleep($aa);
			$parsed = 0;
		}
	}

	$filename = $namefix."-MyLevel.txt";
	if($debug == 1){
		open(FILE, ">>".$filename)
		or die "failed to open file!!!!";
		print FILE "Mylevel\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		s1(); debug("Mylevel"); nl();
	}elsif($debug != 1){
		if(-e $filename){
			unlink($filename)or die "Can't delete $filename: $!\n";
			$filename = "";
		}else{
			$filename = "";
		}
	}else{
		warnformat("error in debug.");
	}

	$a = $mech->content();
			
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto MyLevelTop;
		}

	$a =~ s/<.*?>//sg;
    $a =~ m/(Level : .* Exp)/s;
	$a = $1;
	$a =~ s/,//g;
	$a =~ s/\D//g;
	$MyLev = new Math::BigFloat $a;
	$Forlev = $a;
	while($Forlev =~ m/([0-9]{4})/){
		my $temp1 = reverse $Forlev;
		$temp1 =~ s/(?<=(\d\d\d))(?=(\d))/,/;
		$Forlev = reverse $temp1;
	}
	s1(); general("Your Level is : ".$Forlev); nl();
	
	if($maxlev <= $MyLev){
		s1(); general("You have reached the desired level. Continuing without leveling"); nl();
	}
}	

sub Cpmready{
	CpmreadyTop:
	if($debug == 1){
		s1(); debug("Arrived at cpmready");
	}

	nl();s1(); general("Chaoslord Post Mortem readiness check."); nl();

	$eighttwice = 0;
	$cpmtest = 0;
	$cpmready = 0;
	$won = 1;
	$levmulti = 0;
	$reps = 0;
	while($won == 1){
		$parsed = 0;
		while ($parsed == 0){
			sleep($stime);
			$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
			$a = $mech->content();
			if($a =~ m/Skeleton/){
				$parsed = 1;
			}
			$aa = $a;
			if($aa =~ m/(Stun time .*!<br>Please)/){
				$aa = $1;
				$aa =~ s/<br>Please//g;			
				s4(); warnformat($aa);nl();
				$aa =~ s/Stun time //g;
				$aa =~ s/!//g;
				$aa = $aa + 2;
				s4(); general("Please wait for the stun time to end.");nl();
				sleep($aa);
				$parsed = 0;
			}
		}

		$level = 201;
		$mech->form_number(2);
		$mech->field("Difficulty", $level);
		$mech->click_button(value => "Level");
		$a = $mech->content();
					
		if ($a =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto CpmreadyTop;
		}

			$filename = $namefix."-cpmready.txt";
			if($debug == 1){
				open(FILE, ">>".$filename)
				or die "failed to open file!!!!";
				print FILE "cpm1\n\n";
				print FILE "content\n\n";
				print FILE "$a\n\n";
				close(FILE);
				
				s1(); debug("cpmready1");
			}elsif($debug != 1){
				if(-e $filename){
					unlink($filename)or die "Can't delete $filename: $!\n";
					$filename = "";
				}else{
					$filename = "";
				}
			}else{
				warnformat("error in debug.");
			}

		$cpm = $a;
		$cpm =~ m/(<option>208.*<\/option><option>209)/;
		$cpm = $1;
		$cpm =~ s/<\/option><option>209//g;
		$cpm =~ s/<option>//;

		if($debug == 1){
			s1(); debug("cpm = ".$cpm);
		}
		sleep($stime);
		$mech->select("Monster", $cpm);
		$mech->click_button(value => $fmodeval);
		$b = $mech->content();
					
		if ($b =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto CpmreadyTop;
		}

			$filename = $namefix."-cpmready.txt";
			if($debug == 1){
				open(FILE, ">>".$filename)
				or die "failed to open file!!!!";
				print FILE "cpm2\n\n";
				print FILE "content\n\n";
				print FILE "$b\n\n";
				print FILE "CPM OUTPUT HERE".$cpm."\n\n";
				close(FILE);
				
				s1(); debug("cpmready2");nl();
			}elsif($debug != 1){
				if(-e $filename){
					unlink($filename)or die "Can't delete $filename: $!\n";
					$filename = "";
				}else{
					$filename = "";
				}
			}else{
				warnformat("error in debug.");
			}
		
		if($b =~ m/(You have been slain)/) {
			s1();  lost( "You were slain!");nl();	
			s1(); general("Waiting to recover from stun before continuing . . .");nl();			
			s1(); general("You are not Chaoslord Post Mortem ready.");nl();
			$cpmready = 0;
			$cpmtest = 1;
			sleep(5);
			last;
		}else{
			$cpmtest = 0
		}
		if ($b =~ m/logged/) {
			s1(); infoformat("still logged out, trying again.");
			sleep(5);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			until($a =~ m/Skeleton/){
				$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
				$a = $mech->content();
				s1(); infoformat("still logged out, trying again.");
				sleep($stime);
			}
			s1(); general("We're restarting Chaoslord post mortem readiness test. ");nl();
			Cpmready();
		}
		$won = 0;
	}

	nl();s1(); general("Beginning CPM Test."); nl();

	until ($cpmtest == 1){
		$reps = 0;
		$won = 0;
		$tied = 0;
		$lost = 0;
		sleep($stime);
		CpmtestReload:
		$mech->reload();
		$c = $mech->content();
							
		if ($c =~ m/logged/) {
			s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			goto CpmtestReload;
		}
		
			$filename = $namefix."-cpmready.txt";
			if($debug == 1){
				open(FILE, ">>".$filename)
				or die "failed to open file!!!!";
				print FILE "cpm3\n\n";
				print FILE "content\n\n";
				print FILE "$c\n\n";
				close(FILE);
				
				s1(); debug("cpmready3");
			}elsif($debug != 1){
				if(-e $filename){
					unlink($filename)or die "Can't delete $filename: $!\n";
					$filename = "";
				}else{
					$filename = "";
				}
			}else{
				warnformat("error in debug.");
			}
		$a = $c;
		$a =~ m/(<td valign=top>Level.*<\/font><\/body><\/html>)/s;
		$a = $1;

			$filename = $namefix."-cpmready.txt";
			if($debug == 1){
				open(FILE, ">>".$filename)
				or die "failed to open file!!!!";		
				print FILE "\ncpm4\n\n";
				print FILE $a;
				print FILE "\n";
				close(FILE);

				s1(); debug("cpmready4");
			}elsif($debug != 1){
				if(-e $filename){
					unlink($filename)or die "Can't delete $filename: $!\n";
					$filename = "";
				}else{
					$filename = "";
				}
			}else{
				warnformat("error in debug.");
			}

		if ($b =~ m/You win/) {
			$won++;
			$reps++; 
			s1(); won("Cpm fight ".$reps." You won.")
		}
		if ($b =~ m/battle tied/) {
			$tied++;
			$reps++;
			s1(); draw("Cpm  fight ".$reps." You tied.");
		}
		if ($b =~ m/stunned/) {
			$lost++;
			$reps++;
			s1(); lost("Cpm  fight ".$reps." You lost.");
			s1(); general("Waiting 5 seconds before continuing");
			sleep(6);
			$reps = 10;
		}
		if ($b =~ m/logged/) {
			s1(); infoformat("Logged out, trying again.");
			sleep(2);
			my $relogin_thread = threads->create(\&login);
			$relogin_thread->join();
			s1(); general("We're restarting Chaoslord post mortem readiness test. ");nl();
		}

		until($reps >= 10){
			CpmRepsTop:
			sleep($loopwait); 
			$mech->reload();
			$a = $mech->content();
						
			if ($a =~ m/logged/) {
				s1(); infoformat("LOGGED OUT! Login will start in 2 seconds.");
				sleep(2);
				my $relogin_thread = threads->create(\&login);
				$relogin_thread->join();
				goto CpmRepsTop;
			}

			$b = $a;
			if ($a =~ m/<td valign=top>Level.*<\/font><\/body><\/html>/){
				$a =~ m/(<td valign=top>Level.*<\/font><\/body><\/html>)/s;
				$a = $1;
			}
			$filename = $namefix."-cpmready.txt";
			if($debug == 1){
				open(FILE, ">>".$filename)
				or die "failed to open file!!!!";	
				print FILE "\ncpm5\n\n"; 
				print FILE "content\n\n";	
				print FILE $a;
				print FILE "\n";
				close(FILE);
				
				s1(); debug("cpmready5");
			}elsif($debug != 1){
				if(-e $filename){
					unlink($filename)or die "Can't delete $filename: $!\n";
					$filename = "";
				}else{
					$filename = "";
				}
			}else{
				warnformat("error in debug.");
			}

			if ($b =~ m/You win/) {
				$won++;
				$reps++;
				s1(); won("Cpm fight ".$reps." You won.");
			}
			if ($b =~ m/battle tied/) {
				$tied++;
				$reps++;
				s1(); draw("Cpm fight ".$reps." You tied.");
				if($tied >= 3){$tietrig = 1; $eighttwice = 0; last;}
			}
			if ($b =~ m/stunned/) {
				$lost++;
				$reps++;
				$eighttwice = 0;
				s1(); lost("Cpm fight ".$reps." You lost.");
				s1(); general("Waiting 5 seconds before continuing");
				sleep(6);
				last;
			}			
			if ($b =~ m/logged/) {
				s1(); infoformat("Logged out, trying again.");
				sleep(2);
				my $relogin_thread = threads->create(\&login);
				$relogin_thread->join();
				s1(); general("We're restarting Chaoslord post mortem readiness test. ");nl();
			}
		}

		nl(); 
		@outcomes = ($won, $tied, $lost);
		my $i = 0;
		foreach(@outcomes) {
			if($i == 0){s1(); general("Won    "."$_");}elsif($i == 1){s1(); general("Tied   "."$_");}else{s1(); general("Lost   "."$_");}
			$i++;
		}
		nl(); 

			if($debug == 1){
				s1(); debug("cpmready = ".$cpmready);
				s1(); debug("cpmtest = ".$cpmtest);
				s1(); debug("won = ".$won);
				s1(); debug("tied = ".$tied);
				s1(); debug("lost = ".$lost);
				s1(); debug("reps = ".$reps);
				s1(); debug("eighttwice = ".$eighttwice);	
				s1(); debug("tietrig = ".$tietrig);
			}	

		if($tietrig !=1){
			if($outcomes[0] >=8){ 
				s1(); general("Won 8 or more times."); nl();
				$eighttwice++;
				if($eighttwice == 2){
					s1(); general("You are Chaoslord Post Mortem ready..."); 
					$eighttwice = 0;
					$cpmready = 1;	
					$cpmtest = 1;
					$won = 0;
					$reps = 10;
					last();
				}elsif($eighttwice == 1){
					s1(); general("Trying again for accuracy."); nl();
				}
			}elsif($outcomes[0] <=7 ){
				if($outcomes[2] >= 1){
					s1(); general("Lost a fight."); nl();
					s1(); general("You are not Chaoslord Post Mortem ready."); nl();
					$cpmready = 0;
					$cpmtest = 1;
				}else{
					s1(); general("Won fewer than 8 times out of 10."); nl();
					if($debug == 1){
						s1(); debug("fewer than 8 wins");nl();
					}
					s1(); general("You are nearly Chaoslord Post Mortem ready."); 
					$eighttwice = 0;
					$cpmready = 0;
					$cpmtest = 1;
				}
			}else{
				s1(); general("cpmready error. Something is wrong\n");
			}
		}else{
			if($debug == 1){
				s1(); debug("TIETRIG TRIGGERED");nl();
			}
			s1(); general("Tied more than twice.");nl();
			s1(); general("You are not Chaoslord Post Mortem ready.");nl();
			$cpmready = 0;
			$tietrig = 0;
			$cpmtest = 1;
		}	
		if($debug == 1){
			s1(); debug("cpmready = ".$cpmready);
			s1(); debug("cpmtest = ".$cpmtest);
			s1(); debug("won = ".$won);
			s1(); debug("tied = ".$tied);
			s1(); debug("lost = ".$lost);
			s1(); debug("reps = ".$reps);
			s1(); debug("eighttwice = ".$eighttwice);	
			s1(); debug("tietrig = ".$tietrig);
		}	
	}
	return($cpmready);
}

sub login{
	RETRY:
	if($trycounter == 0){$trycounter = 1;}
	nl();s1(); infoformat("Connection attempt ".$trycounter);nl();
	$parsed = 0; 
	while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."login.php");
		$a = $mech->content();
		$b = $mech->success();
		$c = $mech->response();
		$d = $mech->status();

					$filename = $username."-Loginrecord.txt";
					if($debug == 1){
						open(FILE, ">>".$filename)
						or die "failed to open file!!!!";
						print FILE "all errors and returns from login\n\n";
						print FILE "content\n\n";
						print FILE "$a\n\n";
						print FILE "sucess\n\n";
						print FILE "$b\n\n";
						print FILE "response\n\n";
						print FILE "$c\n\n";
						print FILE "status\n\n";
						print FILE "$d\n\n";
						close(FILE);

						s1(); debug("login"); nl();
						if($requests==1){
							$mech->add_handler("request_preprepare",  sub {s1(); nl();nl();infoformat("PREPREPARE");nl(); warnformat(shift->dump); return });
							$mech->add_handler("request_prepare",  sub {s1(); nl();nl();infoformat("PREPARE");nl(); warnformat(shift->dump); return });
							$mech->add_handler("response_header",  sub {s1();nl();nl();infoformat("RESPONSE HEADER");nl(); warnformat(shift->dump); return });
							$mech->add_handler("request_send",  sub {s1(); nl();nl();infoformat("REQUEST");nl(); warnformat(shift->dump); return });
							$mech->add_handler("response_done", sub {s1(); nl();nl();infoformat("RESPONSE");nl(); warnformat(shift->dump); return });
						}
					}elsif($debug != 1){
						if(-e $filename){
							unlink($filename)or die "Can't delete $filename: $!\n";
							$filename = "";
						}else{
							$filename = "";
						}
					}else{
						warnformat("error in debug.");
					}

	s1(); infoformat("SUCCESS: $b");
	s1(); infoformat("STATUS: $d");
		if($d == 200){
			if($a =~ m/Enter Lol!/){
				$parsed = 1;
			}else{
				$parsed = 0;
				sleep(10);
				goto RETRY;
			}
		}elsif(($d == 500) || ($d == 523)){
			s1(); errorformat("Trouble Connecting to internet....Probably");
			#change back to 30 after test
			sleep(3);
			$trycounter++;
			goto RETRY;
		}
	}
	if($a =~ m/Username/){
		$mech->form_number(0);
		$mech->field("Username", $username);
		$mech->field("Password", $password);
		$mech->click_button('value' => 'Enter Lol!');
		$a = $mech->content();
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		#s1(); general("[$Hour:$Minute:$Second] - logged in Successfully to : ");
		if($a =~ m/Login failed/){
			s1(); errorformat("Login failed.");
			sleep(30);
			goto RETRY;
		}
	}else{
		sleep(5);
		goto RETRY;
	}
}