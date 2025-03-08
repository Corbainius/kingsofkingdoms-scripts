#!/usr/bin/perl

use strict;
use warnings;
use integer;
use Carp;
use Math::BigFloat;
use Math::BigInt;
use Time::HiRes qw(sleep);
use WWW::Mechanize;
use POSIX qw(strftime);

my $trigger = 0;  

if ($#ARGV < 6){
	if ($ARGV[1] >= 1 && $ARGV[1] <= 999999){
		splice(@ARGV, 2, 0, ('password'));
		$trigger = 1;
	}
}	

my $server = $ARGV[0]
or die "Server failed";
my $username = $ARGV[1]
or die "User failed";
my $password = $ARGV[2]
or die "pass failed";
my $loopwait = $ARGV[3]
or die "loopwait failed";
my $chartype = $ARGV[4]
or die "chartype failed";
my $charmbuild = $ARGV[5]
or die "chartype failed";
my $mincharm = $ARGV[6]
or die "mincharm failed";


# Global variables
my($all, $stat);
my(@stats);
my(@logins);
my(@users);
my($parsed,$tmp,$mech);
my($a,$b,$c,$d,$e);
my($c0,$c1,$c2,$c3,$c4,$c5,$c6);
my($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST);
my($clicks);
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
my $wdlevel = new Math::BigFloat;
my $aslevel = new Math::BigFloat;
my $deflevel = new Math::BigFloat;
my $mslevel = new Math::BigFloat;
my $arlevel = new Math::BigFloat;
my $mrlevel = new Math::BigFloat;
my $level = new Math::BigFloat;
my $stealwait;
my $stealtime;
my $mytime;
my $stealcount;
my $intstrlvl = 0;
my $MyLev;
my $masslevel = 1500;
my $Alternate = 60;
my $autolevel;
my $upgrade;
my $charm;
my $charmsfull = 0;
my $charmurl;
my $antal;
my $agilmagecount = 6;
my $charmtype = 0;
my $destroycharm1;
my $destroycharm2;
my $destroycharm3;
my $destroycharm4;
my $destroycharm5;
my $Forlev;
my $charname;
my $title;
my $name = "";
my $DoSearch = "";
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

if($server == 1){
	$URLSERVER = "/m3/";
	$filefix = "m3";
}elsif($server == 2){
	$URLSERVER = "/Elysian-Fields/";
	$filefix = "EF";
}
#---------------------


sub FindThief {
	print "FindThief start\n";
	$parsed = 0; 

		if ($a =~ m/Thief/){
			print "Thief found.\n";
			&CPMlevel;
		}elsif ($a =~ m/Wacko Jacko/){
			print "Finding theif in world list.\n";
		exit();
	}
}

sub CPMlevel {
	sleep(1.2);
	$mech->get("http://www.kingsofkingdoms.com/".$URLSERVER."world.php");
	$a = $mech->content();
	sleep(1.2);
	$mech->get("http://www.kingsofkingdoms.com/".$URLSERVER."world.php");
	$mech->form_number(1);
	$mech->click_button('value' => 'Town [1]');
	$a = $mech->content();
	$parsed = 0; while ($parsed == 0) {sleep(1.2);
#	$mech->get("http://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
	$mech->get("http://www.kingsofkingdoms.com/".$URLSERVER."world_control.php");
	$a = $mech->content();
	if ($a =~ m/Thief/){
		$parsed = 1;
	}else{
			sleep(10);
			exit();
		}
	}
	$mech->form_number(1);
	$mech->click();
	$all = $mech->content();
	#test for free upgrade

	$all =~ m/(Min<br>.*monster)/s;
	$stat = $1;
	$stat =~ m/(\<br.*td\>)/;
	$stat = $1;
	$stat =~ s/<.*?>/:/sg;
	$stat =~ s/\.//g;
	#print $stat;
	@stats = split(/:/, $stat);
	$stats[1] =~ s/,//sg;
	$stats[2] =~ s/,//sg;
	$stats[4] =~ s/,//sg;
	$stats[5] =~ s/,//sg;
	$stats[6] =~ s/,//sg;
	$stats[7] =~ s/,//sg;

	$wdlevel = new Math::BigFloat $stats[1];
	$aslevel = new Math::BigFloat $stats[2];
	$mslevel = new Math::BigFloat $stats[4];
	$deflevel = new Math::BigFloat $stats[5];
	$arlevel = new Math::BigFloat $stats[6];
	$mrlevel = new Math::BigFloat $stats[7];

	#cpms m2 only
    $wdlevel->bdiv('350386'); 
    $aslevel->bdiv('374627'); 
	$mslevel->bdiv('340149');
    $deflevel->bdiv('204081'); 
    $arlevel->bdiv('40864'); 
    $mrlevel->bdiv('40879'); 

	$wdlevel->bfround(1);
	$aslevel->bfround(1);
	$mslevel->bfround(1);
	$deflevel->bfround(1);
	$arlevel->bfround(1);
	$mrlevel->bfround(1);

	$aslevel->bmul('2.5'); # multiplier for correct AS
	$wdlevel->bmul('2.5'); #multiplier for correct wd
	
	if($chartype ==4){
		$wdlevel->bdiv('2.5');
	}
	if($chartype ==5){
		$aslevel->bdiv('2.5');
	}
if($chartype == 1) {
	printf "ASlevel: %.3e", $aslevel->bstr();
	printf ", DEFlevel: %.3e", $deflevel->bstr();
	printf ", MRlevel: %.3e", $mrlevel->bstr();
	}
if($chartype == 2) {
	printf "WDlevel: %.3e", $wdlevel->bstr();
	printf ", ARlevel: %.3e", $arlevel->bstr();
	printf ", MRlevel: %.3e", $mrlevel->bstr();
	}
if($chartype == 3) {
	printf "ASlevel: %.3e", $aslevel->bstr();
	printf ", ARlevel: %.3e", $arlevel->bstr();
	printf ", MRlevel: %.3e", $mrlevel->bstr();
	}
if($chartype == 4) {
	printf "WDlevel: %.3e", $wdlevel->bstr();
	printf ", ARlevel: %.3e", $arlevel->bstr();
	}
if($chartype == 5) {
	printf "ASlevel: %.3e", $aslevel->bstr();
	printf ", MRlevel: %.3e", $mrlevel->bstr();
	}
if($chartype == 6) {
	printf "WDlevel: %.3e", $wdlevel->bstr();
	printf ", MSlevel: %.3e", $mslevel->bstr();
	printf ", ARlevel: %.3e", $arlevel->bstr();
	}
	
	# for agil mage:
	if ($chartype == 1) {
	$level = $aslevel->copy();
	if ($level >= $deflevel) {$level = $deflevel->copy();}
	if ($level >= $mrlevel) {$level = $mrlevel->copy();}
	}
	# for fighter
	if ($chartype == 2) {
	$level = $wdlevel->copy();
	if ($level >= $arlevel) {$level = $arlevel->copy();}
	if ($level >= $mrlevel) {$level = $mrlevel->copy();}
	}
	# for mage
	if ($chartype == 3) {
	$level = $aslevel->copy();
	if ($level >= $arlevel) {$level = $arlevel->copy();}
	if ($level >= $mrlevel) {$level = $mrlevel->copy();}
	}
	# for pure fighter
	if ($chartype == 4) {
	$level = $wdlevel->copy();
	if ($level >= $arlevel) {$level = $arlevel->copy();}
	}
	# for pure mage
	if ($chartype == 5) {
	$level = $aslevel->copy();
	if ($level >= $mrlevel) {$level = $mrlevel->copy();}
	}
	# for contra fighter
	if ($chartype == 6) {
	$level = $wdlevel->copy();
	if ($level >= $mslevel) {$level = $mslevel->copy();}
	if ($level >= $arlevel) {$level = $arlevel->copy();}
	}
	printf " --> Wacko Jacko level: %.3e\n", $level->bstr();
}

sub Fight {
# setup fight
	my($cpm);
	$parsed = 0; while ($parsed == 0) {sleep(1.2);
	$mech->get("http://www.kingsofkingdoms.com/".$URLSERVER."world.php");
	$mech->click_button('value' => 'Hall of Unfame [100]');
	$a = $mech->content();
	if ($a =~ m/Wacko Jacko/){
		$parsed = 1;
	}else{
			sleep(10);
			exit();
		}
	}
	$mech->form_number(2);
	$mech->field("Difficulty", $level);
	$mech->click();
	$cpm = $mech->content();
	$cpm =~ m/(\<option\>100.*Jacko)/;
    $cpm = $1;
	$mech->form_number(1);
	$mech->click();
	$a = $mech->content();
	#test for free upgrade
	if ($a =~ m/Click here to upgrade/) {
		sleep(1.2); $mech->click_button('value' => 'No upgrade');
		print "Free upgrade detected and cleared. Restarting\n";
		&Fight;
	}
	$a =~ m/(You win.*exp )/;
	$a =~ m/(battle)/;
	$a =~ m/(You have been jailed for violating our rules)/;
	#my $antal = 500 + int rand (500);
	
	#$antal = $antal -1;
	#print "$antal: [$Hour:$Minute:$Second] " . $1 . "\n" or die "Failed";
	
	my $jail;
	
# REPEAT:
	while ($antal > 1) {
		sleep($loopwait); #default = 0.3
		$antal = $antal -1;
		$mech->reload();
		$a = $mech->content();
		$b = $a;
		$c = $a;
		$d = $a;
		# KILLED
		if($a =~ m/error/i) {
			print "ERROR. Restarting\n";exit(0);
		}
		if(!$a =~ m/parsed/i) {
			print "Did not parse correctly, Restarting.\n";exit(0);
		}
		if($a =~ m/(been.*slain)/) {
			print "ERROR - TOO HIGH MONSTER LEVEL! - you were slain!\n";exit(0);
		}
		# JAILED
		if ($b =~ m/jail time.*<br>/) {
			print"You have been Jailed - Sleep 5 seconds.\n";
			sleep(5);
			return();
		}
		# LOGGED OUT

		if ($c =~ m/logged/i) {
			print "LOGGED OUT! sleeping for 5 seconds before restart!\n";
			sleep(30);
			exit();
		}
		if($d =~ m/you have 0 charm/i){
				$charmsfull = 0;
		}
		if($d =~ m/you have 1 charm/i){
				$charmsfull = 0;
		}
		if($d =~ m/you have 2 charm/i){
				$charmsfull = 0;
		}
		if($d =~ m/you have 3 charm/i){
				$charmsfull = 0;
		}
		if($d =~ m/you have 4 charm/i){
				$charmsfull = 0;
		}
		if($d =~ m/you found a stats charm/i){
			$charm = "     FOUND A CHARM!!!";
				$charmsfull = 0;
		}
		elsif($d =~ m/5 charms in/i){
				$charm = "     Charm slots are Full";
				$charmsfull = 1;
		}
		else{
			$charm = "";
		}
		$a = $b;
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		if ($a =~ m/(You win.*exp )/){
			print "$antal: [$Hour:$Minute:$Second] " . $1 .  "" . $charm . "\n";
		}
		if ($a =~ m/(The battle tied.)/){
			print "$antal: [$Hour:$Minute:$Second] " . $1 .  "" . $charm . "\n";
		}
		if ($charmsfull == 1){
			if ($d =~ m/Click here to upgrade now!/) {
				sleep(1.2);
				$mech->click_button('value' => 'No upgrade');
				print "$antal: [$Hour:$Minute:$Second] \n";
				print "$antal: [$Hour:$Minute:$Second] ";
				print "                      UPGRADE CLEARED. RESUMING. \n";
				print "$antal: [$Hour:$Minute:$Second] \n";
			}
			&CheckCharms;
		}
		if ($d =~ m/Click here to upgrade now!/) {
			sleep(1.2);
			$mech->click_button('value' => 'No upgrade');
			print "$antal: [$Hour:$Minute:$Second] \n";
			print "$antal: [$Hour:$Minute:$Second] ";
			print "                      UPGRADE CLEARED. RESUMING. \n";
			print "$antal: [$Hour:$Minute:$Second] \n";
			&Fight;
		}
	}
}

sub CheckCharms {
	$parsed = 0;
	while ($parsed == 0){
		sleep(1.2);
		$mech->get("http://www.kingsofkingdoms.com/".$URLSERVER."charms.php");
		$a = $mech->content();
		if ($a =~ m/Parsed/){
			$parsed = 1;
		}else{
			sleep(10);
			exit();
		}
	}
	$b = $a;
	$c = $a;
	$d = $a;
	$e = $a;
	my $temp1;
	my $temp2;
	my $temp3;
	my $temp4;
	my $temp5;
	my $temp6;
	my $charmnumber1;
	my $charmurl1;
	my $charmnumber2;
	my $charmurl2;
	my $charmnumber3;
	my $charmurl3;
	my $charmnumber4;
	my $charmurl4;
	my $charmnumber5;
	my $charmurl5;
	my $charmstr;
	my $charmdex;
	my $charmagil;
	my $charmint;
	my $charmconc;
	my $charmcontra;
	my $charm1score;
	my $charm2score;
	my $charm3score;
	my $charm4score;
	my $charm5score;
	
	#trims trash top
	$a =~ s/(.*)(#5)//sgi; #remove before
	$b =~ s/(.*)(#5)//sgi; #remove before
	$c =~ s/(.*)(#5)//sgi; #remove before
	$d =~ s/(.*)(#5)//sgi; #remove before
	$e =~ s/(.*)(#5)//sgi; #remove before
	#Charm 1
	$a =~ s/Power/a1/s;
	$a =~ s/Destroy charm/a2/s;
	$a =~ s/(.*)(a1)//sgi; #remove before
	$a =~ s/a2.*//s; #remove after
	$charmnumber1 = $a;
		$a =~ s/(.*)(<a href=")//sgi; #remove before
		$a =~ s/>//sg;
		$a =~ s/"//sg;
		$charmurl1 = $a;
		#print "$charmurl1\n";
		#print "$charmnumber1\n";
	#Charm 2
	$b =~ s/Power/a1/s;
	$b =~ s/Destroy charm/a2/s;
	$b =~ s/Power/b1/s;
	$b =~ s/Destroy charm/b2/s;	
	$b =~ s/(.*)(b1)//sgi; #remove before
	$b =~ s/b2.*//s; #remove after
	$charmnumber2 = $b;
		$b =~ s/(.*)(<a href=")//sgi; #remove before
		$b =~ s/>//sg;
		$b =~ s/"//sg;
		$charmurl2 = $b;
		#print "$charmurl2\n";
		#print "$charmnumber2\n";
	
	#Charm 3
	$c =~ s/Power/a1/s;
	$c =~ s/Destroy charm/a2/s;
	$c =~ s/Power/b1/s;
	$c =~ s/Destroy charm/b2/s;	
	$c =~ s/Power/c1/s;
	$c =~ s/Destroy charm/c2/s;	
	$c =~ s/(.*)(c1)//sgi; #remove before
	$c =~ s/c2.*//s; #remove after
	$charmnumber3 = $c;
		$c =~ s/(.*)(<a href=")//sgi; #remove before
		$c =~ s/>//sg;
		$c =~ s/"//sg;
		$charmurl3 = $c;
		#print "$charmurl3\n";
		#print "$charmnumber3\n";
	
	#Charm 4
	$d =~ s/Power/a1/s;
	$d =~ s/Destroy charm/a2/s;
	$d =~ s/Power/b1/s;
	$d =~ s/Destroy charm/b2/s;	
	$d =~ s/Power/c1/s;
	$d =~ s/Destroy charm/c2/s;
	$d =~ s/Power/d1/s;
	$d =~ s/Destroy charm/d2/s;	
	$d =~ s/(.*)(d1)//sgi; #remove before
	$d =~ s/d2.*//s; #remove after
	$charmnumber4 = $d;
		$d =~ s/(.*)(<a href=")//sgi; #remove before
		$d =~ s/>//sg;
		$d =~ s/"//sg;
		$charmurl4 = $d;
		#print "$charmurl4\n";
		#print "$charmnumber4\n";
	
	#Charm 5
	$e =~ s/Power/a1/s;
	$e =~ s/Destroy charm/a2/s;
	$e =~ s/Power/b1/s;
	$e =~ s/Destroy charm/b2/s;	
	$e =~ s/Power/c1/s;
	$e =~ s/Destroy charm/c2/s;
	$e =~ s/Power/d1/s;
	$e =~ s/Destroy charm/d2/s;	
	$e =~ s/Power/e1/s;
	$e =~ s/Destroy charm/e2/s;	
	$e =~ s/(.*)(e1)//sgi; #remove before
	$e =~ s/e2.*//s; #remove after
	$charmnumber5 = $e;
		$e =~ s/(.*)(<a href=")//sgi; #remove before
		$e =~ s/>//sg;
		$e =~ s/"//sg;
		$charmurl5 = $e;
		#print "$charmurl5\n";
		#print "$charmnumber5\n";
	
	#open(FILE, ">charmpageA.txt")
	#or die "failed to open file!!!!";
	#print FILE "$charmnumber1\n";
	#close(FILE);
	#print "A file made\n";
	
	#open(FILE, ">charmpageB.txt")
	#or die "failed to open file!!!!";
	#print FILE "$charmnumber2\n";
	#close(FILE);
	#print"B file made\n";
	
	#open(FILE, ">charmpageC.txt")
	#or die "failed to open file!!!!";
	#print FILE "$charmnumber3\n";
	#close(FILE);
	#print"C file made\n";
	
	#open(FILE, ">charmpageD.txt")
	#or die "failed to open file!!!!";
	#print FILE "$charmnumber4\n";
	#close(FILE);
	#print"D file made\n";
	
	#open(FILE, ">charmpageE.txt")
	#or die "failed to open file!!!!";
	#print FILE "$charmnumber5\n";
	#close(FILE);
	#print"E file made\n";
	
	#charmstats 1
	$temp1 = $charmnumber1;
	$temp2 = $charmnumber1;
	$temp3 = $charmnumber1;
	$temp4 = $charmnumber1;
	$temp5 = $charmnumber1;
	$temp6 = $charmnumber1;
	
	if($temp1 =~ m/Strength/i){
		#print "charm 1 has str\n";
		$temp1 =~ s/\s//sg;
		#print "$temp1\n";
		$temp1 =~ s/%Strength.*//s; #remove after
		#print "$temp1\n";
		$temp1 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp1\n";
		$charmstr = $temp1;
		#print "$charmstr\n";
	}else{
		$charmstr = 0;
		#print "$charmstr\n";
	}
	
	if($temp2 =~ m/Dexterity/i){
		#print "charm 1 has dex\n";
		$temp2 =~ s/\s//sg;
		#print "$temp2\n";
		$temp2 =~ s/%Dexterity.*//s; #remove after
		#print "$temp2\n";
		$temp2 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp2\n";
		$charmdex = $temp2;
		#print "$charmdex\n";
	}else{
		$charmdex = 0;
		#print "$charmdex\n";
	}
	
	if($temp3 =~ m/Agility/i){
		#print "charm 1 has agil\n";
		$temp3 =~ s/\s//sg;
		#print "$temp3\n";
		$temp3 =~ s/%Agility.*//s; #remove after
		#print "$temp3\n";
		$temp3 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp3\n";
		$charmagil = $temp3;
		#print "$charmagil\n";
	}else{
		$charmagil = 0;
		#print "$charmagil\n";
	}
	
	if($temp4 =~ m/Intelligence/i){
		#print "charm 1 has int\n";
		$temp4 =~ s/\s//sg;
		#print "$temp4\n";
		$temp4 =~ s/%Intelligence.*//s; #remove after
		#print "$temp4\n";
		$temp4 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp4\n";
		$charmint = $temp4;
		#print "$charmint\n";
	}else{
		$charmint = 0;
		#print "$charmint\n";
	}
	
	if($temp5 =~ m/Concentration/i){
		#print "charm 1 has con\n";
		$temp5 =~ s/\s//sg;
		#print "$temp5\n";
		$temp5 =~ s/%Concentration.*//s; #remove after
		#print "$temp5\n";
		$temp5 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp5\n";
		$charmconc = $temp5;
		#print "$charmconc\n";
	}else{
		$charmconc = 0;
		#print "$charmconc\n";
	}
	
	if($temp6 =~ m/contravention/i){
		#print "charm 1 has contra\n";
		$temp6 =~ s/\s//sg;
		#print "$temp6\n";
		$temp6 =~ s/%Contravention.*//s; #remove after
		#print "$temp6\n";
		$temp6 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp6\n";
		$charmcontra = $temp6;
		#print "$charmcontra\n";
	}else{
		$charmcontra = 0;
		#print "$charmcontra\n";
	}
	
	print "---------CHARM 1---------\n";
	print "Charm 1 has " . $charmstr .  "% Strength " . $charmdex .  "% Dexterity " . $charmagil .  "% Agility " . $charmint .  "% Intelligence " . $charmconc .  "% Concentration " . $charmcontra .  "% Contravention \n";
	print "\n";	
	if($charmbuild == 1){
			$charm1score = $charmint + $charmconc + $charmagil;
		print "---------SCORE---------\n";
		print "Agilmage Build - Charm 1 scored ". $charm1score . "\n";
		print "\n";
	}
	if($charmbuild == 2){
			$charm1score = $charmstr + $charmdex + $charmconc;
		print "---------SCORE---------\n";
		print "Fighter Build - Charm 1 scored ". $charm1score . "\n";
		print "\n";	
	}
	if($charmbuild == 3){
			$charm1score = $charmint + $charmconc + $charmdex;
		print "---------SCORE---------\n";
		print "Mage Build - Charm 1 scored ". $charm1score . "\n";
		print "\n";	
	}
	if($charmbuild == 4){
			$charm1score = $charmstr + $charmdex;
		print "---------SCORE---------\n";
		print "Pure Fighter Build - Charm 1 scored ". $charm1score . "\n";
		print "\n";
	}
	if($charmbuild == 5){
			$charm1score = $charmint + $charmconc;
		print "---------SCORE---------\n";
		print "Pure Mage Build - Charm 1 scored ". $charm1score . "\n";
		print "\n";
	}
	if($charmbuild == 6){
			$charm1score = $charmstr + $charmdex + $charmcontra;
		print "---------SCORE---------\n";
		print "Contra Fighter Build - Charm 1 scored ". $charm1score . "\n";
		print "\n";
	}
	if($charmbuild == 7){
			$charm1score = $charmstr;
		print "---------SCORE---------\n";
		print "Pure Strength - Charm 1 scored ". $charm1score . "\n";
		print "\n";
	}
	if($charmbuild == 8){
			$charm1score = $charmconc;
		print "---------SCORE---------\n";
		print "Pure Concentration - Charm 1 scored ". $charm1score . "\n";
		print "\n";
	}
	if($charmbuild == 9){
			$charm1score = $charmagil;
		print "---------SCORE---------\n";
		print "Pure Agility - Charm 1 scored ". $charm1score . "\n";
		print "\n";
	}
	if($charmbuild == 10){
			$charm1score = $charmint;
		print "---------SCORE---------\n";
		print "Pure Intelligence - Charm 1 scored ". $charm1score . "\n";
		print "\n";
	}
	if($charmbuild == 11){
			$charm1score = $charmdex;
		print "---------SCORE---------\n";
		print "Pure Dexterity - Charm 1 scored ". $charm1score . "\n";
		print "\n";
	}
	if($charmbuild == 12){
			$charm1score = $charmcontra;
		print "---------SCORE---------\n";
		print "Pure Contravention - Charm 1 scored ". $charm1score . "\n";
		print "\n";
	}

	
	#charmstats 2
	$temp1 = $charmnumber2;
	$temp2 = $charmnumber2;
	$temp3 = $charmnumber2;
	$temp4 = $charmnumber2;
	$temp5 = $charmnumber2;
	$temp6 = $charmnumber2;
	
	if($temp1 =~ m/Strength/i){
		#print "charm 2 has str\n";
		$temp1 =~ s/\s//sg;
		#print "$temp1\n";
		$temp1 =~ s/%Strength.*//s; #remove after
		#print "$temp1\n";
		$temp1 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp1\n";
		$charmstr = $temp1;
		#print "$charmstr\n";
	}else{
		$charmstr = 0;
		#print "$charmstr\n";
	}
	
	if($temp2 =~ m/Dexterity/i){
		#print "charm 2 has dex\n";
		$temp2 =~ s/\s//sg;
		#print "$temp2\n";
		$temp2 =~ s/%Dexterity.*//s; #remove after
		#print "$temp2\n";
		$temp2 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp2\n";
		$charmdex = $temp2;
		#print "$charmdex\n";
	}else{
		$charmdex = 0;
		#print "$charmdex\n";
	}
	
	if($temp3 =~ m/Agility/i){
		#print "charm 2 has agil\n";
		$temp3 =~ s/\s//sg;
		#print "$temp3\n";
		$temp3 =~ s/%Agility.*//s; #remove after
		#print "$temp3\n";
		$temp3 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp3\n";
		$charmagil = $temp3;
		#print "$charmagil\n";
	}else{
		$charmagil = 0;
		#print "$charmagil\n";
	}
	
	if($temp4 =~ m/Intelligence/i){
		#print "charm 2 has int\n";
		$temp4 =~ s/\s//sg;
		#print "$temp4\n";
		$temp4 =~ s/%Intelligence.*//s; #remove after
		#print "$temp4\n";
		$temp4 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp4\n";
		$charmint = $temp4;
		#print "$charmint\n";
	}else{
		$charmint = 0;
		#print "$charmint\n";
	}
	
	if($temp5 =~ m/Concentration/i){
		#print "charm 2 has con\n";
		$temp5 =~ s/\s//sg;
		#print "$temp5\n";
		$temp5 =~ s/%Concentration.*//s; #remove after
		#print "$temp5\n";
		$temp5 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp5\n";
		$charmconc = $temp5;
		#print "$charmconc\n";
	}else{
		$charmconc = 0;
		#print "$charmconc\n";
	}
	
	if($temp6 =~ m/contravention/i){
		#print "charm 2 has contra\n";
		$temp6 =~ s/\s//sg;
		#print "$temp6\n";
		$temp6 =~ s/%Contravention.*//s; #remove after
		#print "$temp6\n";
		$temp6 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp6\n";
		$charmcontra = $temp6;
		#print "$charmcontra\n";
	}else{
		$charmcontra = 0;
		#print "$charmcontra\n";
	}
	
	print "---------CHARM 2---------\n";
	print "Charm 2 has " . $charmstr .  "% Strength " . $charmdex .  "% Dexterity " . $charmagil .  "% Agility " . $charmint .  "% Intelligence " . $charmconc .  "% Concentration " . $charmcontra .  "% Contravention \n";
	print "\n";	
	if($charmbuild == 1){
			$charm2score = $charmint + $charmconc + $charmagil;
		print "---------SCORE---------\n";
		print "Agilmage Build - Charm 2 scored ". $charm2score . "\n";
		print "\n";
	}
	if($charmbuild == 2){
			$charm2score = $charmstr + $charmdex + $charmconc;
		print "---------SCORE---------\n";
		print "Fighter Build - Charm 2 scored ". $charm2score . "\n";
		print "\n";	
	}
	if($charmbuild == 3){
			$charm2score = $charmint + $charmconc + $charmdex;
		print "---------SCORE---------\n";
		print "Mage Build - Charm 2 scored ". $charm2score . "\n";
		print "\n";	
	}
	if($charmbuild == 4){
			$charm2score = $charmstr + $charmdex;
		print "---------SCORE---------\n";
		print "Pure Fighter Build - Charm 2 scored ". $charm2score . "\n";
		print "\n";
	}
	if($charmbuild == 5){
			$charm2score = $charmint + $charmconc;
		print "---------SCORE---------\n";
		print "Pure Mage Build - Charm 2 scored ". $charm2score . "\n";
		print "\n";
	}
	if($charmbuild == 6){
			$charm2score = $charmstr + $charmdex + $charmcontra;
		print "---------SCORE---------\n";
		print "Contra Fighter Build - Charm 2 scored ". $charm2score . "\n";
		print "\n";
	}
	if($charmbuild == 7){
			$charm2score = $charmstr;
		print "---------SCORE---------\n";
		print "Pure Strength - Charm 1 scored ". $charm2score . "\n";
		print "\n";
	}
	if($charmbuild == 8){
			$charm2score = $charmconc;
		print "---------SCORE---------\n";
		print "Pure Concentration - Charm 1 scored ". $charm2score . "\n";
		print "\n";
	}
	if($charmbuild == 9){
			$charm2score = $charmagil;
		print "---------SCORE---------\n";
		print "Pure Agility - Charm 1 scored ". $charm2score . "\n";
		print "\n";
	}
	if($charmbuild == 10){
			$charm2score = $charmint;
		print "---------SCORE---------\n";
		print "Pure Intelligence - Charm 1 scored ". $charm2score . "\n";
		print "\n";
	}
	if($charmbuild == 11){
			$charm2score = $charmdex;
		print "---------SCORE---------\n";
		print "Pure Dexterity - Charm 1 scored ". $charm2score . "\n";
		print "\n";
	}
	if($charmbuild == 12){
			$charm2score = $charmcontra;
		print "---------SCORE---------\n";
		print "Pure Contravention - Charm 1 scored ". $charm2score . "\n";
		print "\n";
	}
	
	#charmstats 3
	$temp1 = $charmnumber3;
	$temp2 = $charmnumber3;
	$temp3 = $charmnumber3;
	$temp4 = $charmnumber3;
	$temp5 = $charmnumber3;
	$temp6 = $charmnumber3;
	
	if($temp1 =~ m/Strength/i){
		#print "charm 3 has str\n";
		$temp1 =~ s/\s//sg;
		#print "$temp1\n";
		$temp1 =~ s/%Strength.*//s; #remove after
		#print "$temp1\n";
		$temp1 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp1\n";
		$charmstr = $temp1;
		#print "$charmstr\n";
	}else{
		$charmstr = 0;
		#print "$charmstr\n";
	}
	
	if($temp2 =~ m/Dexterity/i){
		#print "charm 3 has dex\n";
		$temp2 =~ s/\s//sg;
		#print "$temp2\n";
		$temp2 =~ s/%Dexterity.*//s; #remove after
		#print "$temp2\n";
		$temp2 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp2\n";
		$charmdex = $temp2;
		#print "$charmdex\n";
	}else{
		$charmdex = 0;
		#print "$charmdex\n";
	}
	
	if($temp3 =~ m/Agility/i){
		#print "charm 3 has agil\n";
		$temp3 =~ s/\s//sg;
		#print "$temp3\n";
		$temp3 =~ s/%Agility.*//s; #remove after
		#print "$temp3\n";
		$temp3 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp3\n";
		$charmagil = $temp3;
		#print "$charmagil\n";
	}else{
		$charmagil = 0;
		#print "$charmagil\n";
	}
	
	if($temp4 =~ m/Intelligence/i){
		#print "charm 3 has int\n"; 
		$temp4 =~ s/\s//sg;
		#print "$temp4\n";
		$temp4 =~ s/%Intelligence.*//s; #remove after
		#print "$temp4\n";
		$temp4 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp4\n";
		$charmint = $temp4;
		#print "$charmint\n";
	}else{
		$charmint = 0;
		#print "$charmint\n";
	}
	
	if($temp5 =~ m/Concentration/i){
		#print "charm 3 has con\n";
		$temp5 =~ s/\s//sg;
		#print "$temp5\n";
		$temp5 =~ s/%Concentration.*//s; #remove after
		#print "$temp5\n";
		$temp5 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp5\n";
		$charmconc = $temp5;
		#print "$charmconc\n";
	}else{
		$charmconc = 0;
		#print "$charmconc\n";
	}
	
	if($temp6 =~ m/contravention/i){
		#print "charm 3 has contra\n";
		$temp6 =~ s/\s//sg;
		#print "$temp6\n";
		$temp6 =~ s/%Contravention.*//s; #remove after
		#print "$temp6\n";
		$temp6 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp6\n";
		$charmcontra = $temp6;
		#print "$charmcontra\n";
	}else{
		$charmcontra = 0;
		#print "$charmcontra\n";
	}
	
	print "---------CHARM 3---------\n";
	print "Charm 3 has " . $charmstr .  "% Strength " . $charmdex .  "% Dexterity " . $charmagil .  "% Agility " . $charmint .  "% Intelligence " . $charmconc .  "% Concentration " . $charmcontra .  "% Contravention \n";
	print "\n";	
	if($charmbuild == 1){
			$charm3score = $charmint + $charmconc + $charmagil;
		print "---------SCORE---------\n";
		print "Agilmage Build - Charm 3 scored ". $charm3score . "\n";
		print "\n";
	}
	if($charmbuild == 2){
			$charm3score = $charmstr + $charmdex + $charmconc;
		print "---------SCORE---------\n";
		print "Fighter Build - Charm 3 scored ". $charm3score . "\n";
		print "\n";	
	}
	if($charmbuild == 3){
			$charm3score = $charmint + $charmconc + $charmdex;
		print "---------SCORE---------\n";
		print "Mage Build - Charm 3 scored ". $charm3score . "\n";
		print "\n";	
	}
	if($charmbuild == 4){
			$charm3score = $charmstr + $charmdex;
		print "---------SCORE---------\n";
		print "Pure Fighter Build - Charm 3 scored ". $charm3score . "\n";
		print "\n";
	}
	if($charmbuild == 5){
			$charm3score = $charmint + $charmconc;
		print "---------SCORE---------\n";
		print "Pure Mage Build - Charm 3 scored ". $charm3score . "\n";
		print "\n";
	}
	if($charmbuild == 6){
			$charm3score = $charmstr + $charmdex + $charmcontra;
		print "---------SCORE---------\n";
		print "Contra Fighter Build - Charm 3 scored ". $charm3score . "\n";
		print "\n";
	}
	if($charmbuild == 7){
			$charm3score = $charmstr;
		print "---------SCORE---------\n";
		print "Pure Strength - Charm 1 scored ". $charm3score . "\n";
		print "\n";
	}
	if($charmbuild == 8){
			$charm3score = $charmconc;
		print "---------SCORE---------\n";
		print "Pure Concentration - Charm 1 scored ". $charm3score . "\n";
		print "\n";
	}
	if($charmbuild == 9){
			$charm3score = $charmagil;
		print "---------SCORE---------\n";
		print "Pure Agility - Charm 1 scored ". $charm3score . "\n";
		print "\n";
	}
	if($charmbuild == 10){
			$charm3score = $charmint;
		print "---------SCORE---------\n";
		print "Pure Intelligence - Charm 1 scored ". $charm3score . "\n";
		print "\n";
	}
	if($charmbuild == 11){
			$charm3score = $charmdex;
		print "---------SCORE---------\n";
		print "Pure Dexterity - Charm 1 scored ". $charm3score . "\n";
		print "\n";
	}
	if($charmbuild == 12){
			$charm3score = $charmcontra;
		print "---------SCORE---------\n";
		print "Pure Contravention - Charm 1 scored ". $charm3score . "\n";
		print "\n";
	}
	
	#charmstats 4
	$temp1 = $charmnumber4;
	$temp2 = $charmnumber4;
	$temp3 = $charmnumber4;
	$temp4 = $charmnumber4;
	$temp5 = $charmnumber4;
	$temp6 = $charmnumber4;
	
	if($temp1 =~ m/Strength/i){
		#print "charm 4 has str\n";
		$temp1 =~ s/\s//sg;
		#print "$temp1\n";
		$temp1 =~ s/%Strength.*//s; #remove after
		#print "$temp1\n";
		$temp1 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp1\n";
		$charmstr = $temp1;
		#print "$charmstr\n";
	}else{
		$charmstr = 0;
		#print "$charmstr\n";
	}
	
	if($temp2 =~ m/Dexterity/i){
		#print "charm 4 has dex\n";
		$temp2 =~ s/\s//sg;
		#print "$temp2\n";
		$temp2 =~ s/%Dexterity.*//s; #remove after
		#print "$temp2\n";
		$temp2 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp2\n";
		$charmdex = $temp2;
		#print "$charmdex\n";
	}else{
		$charmdex = 0;
		#print "$charmdex\n";
	}
	
	if($temp3 =~ m/Agility/i){
		#print "charm 4 has agil\n";
		$temp3 =~ s/\s//sg;
		#print "$temp3\n";
		$temp3 =~ s/%Agility.*//s; #remove after
		#print "$temp3\n";
		$temp3 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp3\n";
		$charmagil = $temp3;
		#print "$charmagil\n";
	}else{
		$charmagil = 0;
		#print "$charmagil\n";
	}
	
	if($temp4 =~ m/Intelligence/i){
		#print "charm 4 has int\n";
		$temp4 =~ s/\s//sg;
		#print "$temp4\n";
		$temp4 =~ s/%Intelligence.*//s; #remove after
		#print "$temp4\n";
		$temp4 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp4\n";
		$charmint = $temp4;
		#print "$charmint\n";
	}else{
		$charmint = 0;
		#print "$charmint\n";
	}
	
	if($temp5 =~ m/Concentration/i){
		#print "charm 4 has con\n";
		$temp5 =~ s/\s//sg;
		#print "$temp5\n";
		$temp5 =~ s/%Concentration.*//s; #remove after
		#print "$temp5\n";
		$temp5 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp5\n";
		$charmconc = $temp5;
		#print "$charmconc\n";
	}else{
		$charmconc = 0;
		#print "$charmconc\n";
	}
	
	if($temp6 =~ m/contravention/i){
		#print "charm 4 has contra\n";
		$temp6 =~ s/\s//sg;
		#print "$temp6\n";
		$temp6 =~ s/%Contravention.*//s; #remove after
		#print "$temp6\n";
		$temp6 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp6\n";
		$charmcontra = $temp6;
		#print "$charmcontra\n";
	}else{
		$charmcontra = 0;
		#print "$charmcontra\n";
	}

	print "---------CHARM 4---------\n";
	print "Charm 4 has " . $charmstr .  "% Strength " . $charmdex .  "% Dexterity " . $charmagil .  "% Agility " . $charmint .  "% Intelligence " . $charmconc .  "% Concentration " . $charmcontra .  "% Contravention \n";
	print "\n";	
	if($charmbuild == 1){
			$charm4score = $charmint + $charmconc + $charmagil;
		print "---------SCORE---------\n";
		print "Agilmage Build - Charm 4 scored ". $charm4score . "\n";
		print "\n";
	}
	if($charmbuild == 2){
			$charm4score = $charmstr + $charmdex + $charmconc;
		print "---------SCORE---------\n";
		print "Fighter Build - Charm 4 scored ". $charm4score . "\n";
		print "\n";	
	}
	if($charmbuild == 3){
			$charm4score = $charmint + $charmconc + $charmdex;
		print "---------SCORE---------\n";
		print "Mage Build - Charm 4 scored ". $charm4score . "\n";
		print "\n";	
	}
	if($charmbuild == 4){
			$charm4score = $charmstr + $charmdex;
		print "---------SCORE---------\n";
		print "Pure Fighter Build - Charm 4 scored ". $charm4score . "\n";
		print "\n";
	}
	if($charmbuild == 5){
			$charm4score = $charmint + $charmconc;
		print "---------SCORE---------\n";
		print "Pure Mage Build - Charm 4 scored ". $charm4score . "\n";
		print "\n";
	}
	if($charmbuild == 6){
			$charm4score = $charmstr + $charmdex + $charmcontra;
		print "---------SCORE---------\n";
		print "Contra Fighter Build - Charm 4 scored ". $charm4score . "\n";
		print "\n";
	}
	if($charmbuild == 7){
			$charm4score = $charmstr;
		print "---------SCORE---------\n";
		print "Pure Strength - Charm 1 scored ". $charm4score . "\n";
		print "\n";
	}
	if($charmbuild == 8){
			$charm4score = $charmconc;
		print "---------SCORE---------\n";
		print "Pure Concentration - Charm 1 scored ". $charm4score . "\n";
		print "\n";
	}
	if($charmbuild == 9){
			$charm4score = $charmagil;
		print "---------SCORE---------\n";
		print "Pure Agility - Charm 1 scored ". $charm4score . "\n";
		print "\n";
	}
	if($charmbuild == 10){
			$charm4score = $charmint;
		print "---------SCORE---------\n";
		print "Pure Intelligence - Charm 1 scored ". $charm4score . "\n";
		print "\n";
	}
	if($charmbuild == 11){
			$charm4score = $charmdex;
		print "---------SCORE---------\n";
		print "Pure Dexterity - Charm 1 scored ". $charm4score . "\n";
		print "\n";
	}
	if($charmbuild == 12){
			$charm4score = $charmcontra;
		print "---------SCORE---------\n";
		print "Pure Contravention - Charm 1 scored ". $charm4score . "\n";
		print "\n";
	}
	
	#charmstats 5
	$temp1 = $charmnumber5;
	$temp2 = $charmnumber5;
	$temp3 = $charmnumber5;
	$temp4 = $charmnumber5;
	$temp5 = $charmnumber5;
	$temp6 = $charmnumber5;
	
	if($temp1 =~ m/Strength/i){
		#print "charm 5 has str\n";
		$temp1 =~ s/\s//sg;
		#print "$temp1\n";
		$temp1 =~ s/%Strength.*//s; #remove after
		#print "$temp1\n";
		$temp1 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp1\n";
		$charmstr = $temp1;
		#print "$charmstr\n";
	}else{
		$charmstr = 0;
		#print "$charmstr\n";
	}
	
	if($temp2 =~ m/Dexterity/i){
		#print "charm 5 has dex\n";
		$temp2 =~ s/\s//sg;
		#print "$temp2\n";
		$temp2 =~ s/%Dexterity.*//s; #remove after
		#print "$temp2\n";
		$temp2 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp2\n";
		$charmdex = $temp2;
		#print "$charmdex\n";
	}else{
		$charmdex = 0;
		#print "$charmdex\n";
	}
	
	if($temp3 =~ m/Agility/i){
		#print "charm 5 has agil\n";
		$temp3 =~ s/\s//sg;
		#print "$temp3\n";
		$temp3 =~ s/%Agility.*//s; #remove after
		#print "$temp3\n";
		$temp3 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp3\n";
		$charmagil = $temp3;
		#print "$charmagil\n";
	}else{
		$charmagil = 0;
		#print "$charmagil\n";
	}
	
	if($temp4 =~ m/Intelligence/i){
		#print "charm 5 has int\n"; 
		$temp4 =~ s/\s//sg;
		#print "$temp4\n";
		$temp4 =~ s/%Intelligence.*//s; #remove after
		#print "$temp4\n";
		$temp4 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp4\n";
		$charmint = $temp4;
		#print "$charmint\n";
	}else{
		$charmint = 0;
		#print "$charmint\n";
	}
	
	if($temp5 =~ m/Concentration/i){
		#print "charm 5 has con\n";
		$temp5 =~ s/\s//sg;
		#print "$temp5\n";
		$temp5 =~ s/%Concentration.*//s; #remove after
		#print "$temp5\n";
		$temp5 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp5\n";
		$charmconc = $temp5;
		#print "$charmconc\n";
	}else{
		$charmconc = 0;
		#print "$charmconc\n";
	}
	
	if($temp6 =~ m/contravention/i){
		#print "charm 5 has contra\n";
		$temp6 =~ s/\s//sg;
		#print "$temp6\n";
		$temp6 =~ s/%Contravention.*//s; #remove after
		#print "$temp6\n";
		$temp6 =~ s/(.*)(\+)+//sgi; #remove before
		#print "$temp6\n";
		$charmcontra = $temp6;
		#print "$charmcontra\n";
	}else{
		$charmcontra = 0;
		#print "$charmcontra\n";
	}
	print "---------CHARM 5---------\n";
	print "Charm 5 has " . $charmstr .  "% Strength " . $charmdex .  "% Dexterity " . $charmagil .  "% Agility " . $charmint .  "% Intelligence " . $charmconc .  "% Concentration " . $charmcontra .  "% Contravention \n";
	print "\n";	
	if($charmbuild == 1){
			$charm5score = $charmint + $charmconc + $charmagil;
		print "---------SCORE---------\n";
		print "Agilmage Build - Charm 5 scored ". $charm5score . "\n";
		print "\n";
	}
	if($charmbuild == 2){
			$charm5score = $charmstr + $charmdex + $charmconc;
		print "---------SCORE---------\n";
		print "Fighter Build - Charm 5 scored ". $charm5score . "\n";
		print "\n";	
	}
	if($charmbuild == 3){
			$charm5score = $charmint + $charmconc + $charmdex;
		print "---------SCORE---------\n";
		print "Mage Build - Charm 5 scored ". $charm5score . "\n";
		print "\n";	
	}
	if($charmbuild == 4){
			$charm5score = $charmstr + $charmdex;
		print "---------SCORE---------\n";
		print "Pure Fighter Build - Charm 5 scored ". $charm5score . "\n";
		print "\n";
	}
	if($charmbuild == 5){
			$charm5score = $charmint + $charmconc;
		print "---------SCORE---------\n";
		print "Pure Mage Build - Charm 5 scored ". $charm5score . "\n";
		print "\n";
	}
	if($charmbuild == 6){
			$charm5score = $charmstr + $charmdex + $charmcontra;
		print "---------SCORE---------\n";
		print "Contra Fighter Build - Charm 5 scored ". $charm5score . "\n";
		print "\n";
	}
	if($charmbuild == 7){
			$charm5score = $charmstr;
		print "---------SCORE---------\n";
		print "Pure Strength - Charm 1 scored ". $charm5score . "\n";
		print "\n";
	}
	if($charmbuild == 8){
			$charm5score = $charmconc;
		print "---------SCORE---------\n";
		print "Pure Concentration - Charm 1 scored ". $charm5score . "\n";
		print "\n";
	}
	if($charmbuild == 9){
			$charm5score = $charmagil;
		print "---------SCORE---------\n";
		print "Pure Agility - Charm 1 scored ". $charm5score . "\n";
		print "\n";
	}
	if($charmbuild == 10){
			$charm5score = $charmint;
		print "---------SCORE---------\n";
		print "Pure Intelligence - Charm 1 scored ". $charm5score . "\n";
		print "\n";
	}
	if($charmbuild == 11){
			$charm5score = $charmdex;
		print "---------SCORE---------\n";
		print "Pure Dexterity - Charm 1 scored ". $charm5score . "\n";
		print "\n";
	}
	if($charmbuild == 12){
			$charm5score = $charmcontra;
		print "---------SCORE---------\n";
		print "Pure Contravention - Charm 1 scored ". $charm5score . "\n";
		print "\n";
	}
	
	my $charmtotal;
	$charmtotal = $charm1score + $charm2score + $charm3score + $charm4score + $charm5score;
	print "Current total Charm Score = " . $charmtotal . "\n";
	
	if ($charm1score < $mincharm){
		$destroycharm1 = $charmurl1;
		print "$destroycharm1\n";
	}else{
		$destroycharm1 = 0;
	}
	if ($charm2score < $mincharm){
		$destroycharm2 = $charmurl2;
		print "$destroycharm2\n";
	}else{
		$destroycharm2 = 0;
	}
	if ($charm3score < $mincharm){
		$destroycharm3 = $charmurl3;
		print "$destroycharm3\n";
	}else{
		$destroycharm3 = 0;
	}	
	if ($charm4score < $mincharm){
		$destroycharm4 = $charmurl4;
		print "$destroycharm4\n";
	}else{
		$destroycharm4 = 0;
	}
	if ($charm5score < $mincharm){
		$destroycharm5 = $charmurl5;
		print "$destroycharm5\n";
	}else{
		$destroycharm5 = 0;
	}
	if(($charm1score >= $mincharm) && ($charm2score >= $mincharm) && ($charm3score >= $mincharm) && ($charm4score >= $mincharm) && ($charm5score >= $mincharm)){
		print "All Charms score greater than " . $mincharm . "\n";
		sleep(30);
		exit();
	}else{
		&Destroycharm;
	}
}

sub Destroycharm {
	if ($destroycharm1 =~ m/docharm/i){
		$parsed = 0;
		while ($parsed == 0){
			sleep(1.2);
			$mech->get("http://www.kingsofkingdoms.com/".$URLSERVER."charms.php");
			$a = $mech->content();
		if ($a =~ m/Parsed/){
			$parsed = 1;
		}else{
				sleep(10);
				exit();
		}
	}
			sleep(1.2);
			$mech->follow_link(url => "$destroycharm1");
			print "                      CHARM 1 DESTROYED. \n";
	}else{
		print "Charm 1 was not destroyed\n";
	}
	if ($destroycharm2 =~ m/docharm/i){
		$parsed = 0;
		while ($parsed == 0){
		sleep(1.2);
		$mech->get("http://www.kingsofkingdoms.com/".$URLSERVER."charms.php");
		$a = $mech->content();
		if ($a =~ m/Parsed/){
		$parsed = 1;
		}else{
				sleep(10);
				exit();
			}
		}
			sleep(1.2);
			$mech->follow_link(url => "$destroycharm2");
			print "                      CHARM 2 DESTROYED. \n";
	}else{
		print "Charm 2 was not destroyed\n";
	}
	if ($destroycharm3 =~ m/docharm/i){
		$parsed = 0;
		while ($parsed == 0){
		sleep(1.2);
		$mech->get("http://www.kingsofkingdoms.com/".$URLSERVER."charms.php");
		$a = $mech->content();
		if ($a =~ m/Parsed/){
		$parsed = 1;
		}else{
				sleep(10);
				exit();
			}
		}
			sleep(1.2);
			$mech->follow_link(url => "$destroycharm3");
			print "                      CHARM 3 DESTROYED. \n";
	}else{
		print "Charm 3 was not destroyed\n";
	}
	if ($destroycharm4 =~ m/docharm/i){
		$parsed = 0;
		while ($parsed == 0){
		sleep(1.2);
		$mech->get("http://www.kingsofkingdoms.com/".$URLSERVER."charms.php");
		$a = $mech->content();
		if ($a =~ m/Parsed/){
		$parsed = 1;
		}else{
				sleep(10);
				exit();
			}
		}
			sleep(1.2);
			$mech->follow_link(url => "$destroycharm4");
			print "                      CHARM 4 DESTROYED. \n";
	}else{
		print "Charm 4 was not destroyed\n";
	}
	if ($destroycharm5 =~ m/docharm/i){
		$parsed = 0;
		while ($parsed == 0){
		sleep(1.2);
		$mech->get("http://www.kingsofkingdoms.com/".$URLSERVER."charms.php");
		$a = $mech->content();
		if ($a =~ m/Parsed/){
		$parsed = 1;
		}else{
				sleep(10);
				exit();
			}
		}
			sleep(1.2);
			$mech->follow_link(url => "$destroycharm5");
			print "                      CHARM 5 DESTROYED. \n";
	}else{
		print "Charm 5 was not destroyed\n";
	}
	exit();
}


sub MyLevel{
	$parsed = 0; 
	while (!$parsed){
		sleep(1.2);
		$mech->get("http://www.kingsofkingdoms.com/".$URLSERVER."main.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
		}
	}
	
$a = $mech->content();
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
	print "Your Level is : $Forlev\n\n";
}	

sub Charname{
	$parsed = 0; 
	while ($parsed == 0){
		sleep(1.2);
		$mech->get("http://www.kingsofkingdoms.com/".$URLSERVER."stats.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
		}
	}
	$a = $mech->content();
	$b = $mech->content();
	$c = $mech->content();
	$a =~ s/(.*)(natural)//si; #remove before
	$a =~ s/<\/th.*//si; #remove after
	$a =~ s/(.*)(for)//si; #remove before
	$charname = $a;
	$charname =~ m/(\w+)\s+(\w+)/;
	$title = $1;
	$name = $2;
	$title =~ s/ //sgi;
	$name =~ s/ //sgi;
	print "\nSuccessfully logged into $title $name at $Hour:$Minute:$Second\n\n";
	
	$b =~ m/(You need.*exp )/;
	$b = $1;
	$b =~ s/you//i;
	$b =~ s/need//i;
	$b =~ s/exp//i;
	$b =~ s/,//gi;
	$b =~ s/\s//gi;
	$Nextlevel = new Math::BigFloat $b;

}

#---------------------
# MAIN
#---------------------

# create a new browser

$mech = WWW::Mechanize->new(autocheck => 0, stack_depth => 0, onerror => \&Carp::croak, timeout => 2);
$mech->agent_alias( 'Windows Mozilla' );

		#$mech->add_handler("request_send",  sub {print"\n\n REQUEST \n\n"; shift->dump; return });
		#$mech->add_handler("response_done", sub {print"\n\n RESPONSE \n\n"; shift->dump; return });

print " 
          \\\\\\///
         / _  _ \\\
       (| (.)(.) |)
.----.OOOo--()--oOOO.----.
|                        |
|www.kingsofkingdoms.com |
|                        |
'----.oooO---------------'
     (   )   Oooo.
      \\\ (    (   )
       \\\_)    ) /
             (_/
\n";

#Login
if($server == 1){
	open(LOGINS, "m3logins.txt")
		or die "failed to open Logins file!!!!";
		@logins = <LOGINS>;
	close(LOGINS);
}elsif($server == 2){
	open(LOGINS, "EFlogins.txt")
		or die "failed to open Logins file!!!!";
		@logins = <LOGINS>;
	close(LOGINS);
}

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
	print"No logins found.";
	sleep(1);
	exit();
}

$parsed = 0; 
while ($parsed == 0){
sleep(1);
$mech->get("http://www.kingsofkingdoms.com/".$URLSERVER."login.php");
$a = $mech->content();
$b = $mech->success();
$c = $mech->response();
$d = $mech->status();
print "SUCCESS: $b\nSTATUS: $d\n\n";
	if($d == 200){
		if($a =~ m/Enter Lol!/){
			$parsed = 1;
		}else{
			sleep(10);
			exit();
		}
	}elsif(($d == 500) || ($d == 523)){
		print "Trouble Connecting to internet....Probably\n";
		sleep(30);
		exit();
	}
}

if($a =~ m/Username/){
	$mech->form_number(0);
	$mech->field("Username", $username);
	$mech->field("Password", $password);
	$mech->click_button('value' => 'Enter Lol!');
	$a = $mech->content();
	($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
	#print "[$Hour:$Minute:$Second] - logged in Successfully to : \n";
}else{
	sleep(5);
	exit();
}

if($a =~ m/Login failed/){
	print"Login failed.\n";
	sleep(30);
	exit();
}elsif($a =~ m/Main Overview/){
	print "\nSuccessfully logged into $title $name at $Hour:$Minute:$Second\n\n";
}

my $levels = 9999999;

while($levels){
	$antal = 901;
	&Charname;
	&MyLevel;
	&CPMlevel;
	&Fight;
	$levels = $levels - 1;
}


exit();
