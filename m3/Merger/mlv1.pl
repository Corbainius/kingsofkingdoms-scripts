#!/usr/bin/perl
RESTART:
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

my $username = $ARGV[0]
or die "username error";
my $password = $ARGV[1]
or die "password error";
my $loopwait = $ARGV[2]
or die "loopwait error";
my $chartype = $ARGV[3]
or die "chartype error";
my $shopyesno = $ARGV[4]
or die "Shops on or off";
my $maxlev = $ARGV[5] 
or die "maxlev error";
my $Chall = $ARGV[6] 
or die "chall error";

# Global variables
my($all, $stat);
my(@stats);
my(@logins);
my(@users);
my($parsed,$tmp,$mech);
my($a,$b,$c);
my($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST);
my($str,$dex,$agil,$int,$conc,$contra);
my($clicks);
my $users;
my $datestring;
my $charname;
my $title;
my $name = "";
my $DoSearch = "";
my $ExPCurrent = new Math::BigFloat;
my $antal = new Math::BigFloat;
my $wdlevel = new Math::BigFloat;
my $aslevel = new Math::BigFloat;
my $mslevel = new Math::BigFloat;
my $deflevel = new Math::BigFloat;
my $arlevel = new Math::BigFloat;
my $mrlevel = new Math::BigFloat;
my $level = new Math::BigFloat;
my $noaction = 0;
my $stealwait;
my $stealtime;
my $stealantal = new Math::BigFloat;
my $mytime;
my $stealcount;
my $intstrlvl = 0;
my $MergeList;
my $Mergeready;
my $MergeId;
my $MergeName;
my $autolevel;
my $MyLev;
my $masslevel = 1500;
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
my $purebuild = 180;
my $LevFinish = 0;
my $Shopped = 0;
my $ReqExp = 0;
my $perstat=0;
my $forstr = 0;
my $fordex = 0;
my $foragil = 0;
my $forint = 0;
my $forconc = 0;
my $forcontra = 0;

if($chartype == 7){
	print "SINGLE STAT MODE, make sure you have selected the right stat.\n";
	$shopyesno = 2;
}
if($chartype == 8){
	print "SINGLE STAT MODE, make sure you have selected the right stat.\n";
	$shopyesno = 2;
}
if($chartype == 9){
	print "SINGLE STAT MODE, make sure you have selected the right stat.\n";
	$shopyesno = 2;
}
if($chartype == 10){
	print "SINGLE STAT MODE, make sure you have selected the right stat.\n";
	$shopyesno = 2;
}
if($chartype == 11){
	print "SINGLE STAT MODE, make sure you have selected the right stat.\n";
	$shopyesno = 2;
}
if($chartype == 12){
	print "SINGLE STAT MODE, make sure you have selected the right stat.\n";
	$shopyesno = 2;
}
	$URLSERVER = "/m3/";
	$filefix = "m3";
#---------------------
($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);

sub Lowlevel {
	$parsed = 0; 
	while ($parsed == 0){
		sleep(1);
#		$mech->get("https://www.kingsofkingdoms.com".$URLSERVER."fight_control.php");
		$mech->get("https://www.kingsofkingdoms.com".$URLSERVER."world_control.php");
		$a = $mech->content();
		if ($a =~ m/Thief/){
			$parsed = 1;
			($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		}else{
			sleep(10);
			goto RESTART;
		}
	}
	$mech->form_number(1);
	$mech->click();
	$all = $mech->content();
	#test for free upgrade
	if ($all =~ m/Click here to upgrade/) {
		sleep(1); $mech->form_number(0);$mech->click();
		print "Free upgrade detected and cleared. Restarting\n";
		goto START;
	}
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
    $wdlevel->bdiv('603'); 
    $aslevel->bdiv('554'); 
    $mslevel->bdiv('84'); 
    $deflevel->bdiv('42'); 
    $arlevel->bdiv('57'); 
    $mrlevel->bdiv('72'); 

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
	
	# for agi mage:
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
	if ($chartype == 6) {
	$level = $wdlevel->copy();
	if ($level >= $mslevel) {$level = $mslevel->copy();}
	if ($level >= $arlevel) {$level = $arlevel->copy();}
	}

	printf " --> Skeleton level: %.3e\n", $level->bstr();
}

sub LowFight {
# setup fight
	my($cpm);
	$parsed = 0;
	while ($parsed == 0){
		sleep(1);
		$mech->get("https://www.kingsofkingdoms.com".$URLSERVER."fight_control.php");
		$a = $mech->content();
		if ($a =~ m/Skeleton/){
			$parsed = 1;
			($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		}else{
			sleep(10);
			goto RESTART;
		}
	}
	$mech->form_number(2);
	$mech->field("Difficulty", $level);
	$mech->click();
	$mech->form_number(1);
	$mech->click();
	$a = $mech->content();
	$a =~ m/(You win.*exp )/;
	$a =~ m/(battle)/;
	$a =~ m/(You have been jailed for violating our rules)/;
	#print $1 . "\n";
	#my $antal = 500 + int rand (500);
	$antal = 60;
	my $jail;

# REPEAT:
	while($antal > 0) {
		sleep($loopwait); #default = 0.3
		$antal = $antal -1;
		$mech->reload();
		$a = $mech->content();
		$b = $a;
		$c = $a;
# KILLED
		if($a =~ m/(been.*slain)/) {
			print "ERROR - TOO HIGH MONSTER LEVEL! - you were slain!\n";goto START;
		}
# JAILED
		if ($b =~ m/jail time.*<br>/) {
			print"You have been Jailed - Sleep 5 seconds.\n";
			sleep(5);
		}

# LOGGED OUT

		if ($c =~ m/logged/) {
			print "LOGGED OUT! sleeping for 5 seconds before restart!\n";
			sleep(5);
			goto START;
		}


# STEAL TIME? then exit to steal
		if ($antal <= 0) {
			goto START;
		}
		
		
		$a = $b;
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		$a =~ m/(You win.*exp )/;
		$a =~ m/(The battle tied.)/;
		print "$antal :[$Hour:$Minute:$Second]: " . $1 . "\n";
	}
}

sub Autolevelup {
	$parsed = 0; while ($parsed == 0) {sleep(1);
	$mech->get("https://www.kingsofkingdoms.com".$URLSERVER."stats.php");
	$a = $mech->content();
	if ($a =~ m/Parsed/){
		$parsed = 1;
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
	}else{
			sleep(10);
			goto RESTART;
		}
	}
	$a = "";
	$b = $mech->content();
	my $availablelevels = $mech->content();
	$availablelevels =~ m/(You have .* levels)/;
	$availablelevels = $1;
	$availablelevels =~ s/You have //s;
	$availablelevels =~ s/ levels//s;
	$availablelevels =~ s/,//gs;
	if($availablelevels < 1){$availablelevels = 0;}
	my $ActualLevel = $MyLev;
	$b =~ m/(Level : .*Exp :)/;
	$b = $1;
	my $accclev = $b;
	$b =~ s/<\/td> .*//si;
	$b =~ s/Level : //si;
	$accclev =~ s/,//sig;
	$accclev =~ m/(\d+)/;
	$accclev = $1;

	if(($availablelevels >= 1) && ($maxlev > $accclev)){
		$a = $maxlev-$accclev;
		if($a >= $availablelevels){
			$a = $availablelevels;
		}
		if ($chartype == 1) {
			if($a>=7){
				$perstat = $a/7;
				$perstat = int($perstat);
				$str = 0;
				$dex = 0;
				$agil = $perstat;
				$int = $perstat*2;
				$conc = $perstat*4;
				$contra = 0;
			}else{
				$str = 0;
				$dex = 0;
				$agil = 0;
				$int = $a;
				$conc = 0;
				$contra = 0;
			}
		}
		if ($chartype == 2) {
			if($a>=4){
				$perstat = $a/4;
				$perstat = int($perstat);
				$str = $perstat*2;
				$dex = $perstat;
				$agil = 0;
				$int = 0;
				$conc = $perstat;
				$contra = 0;
			}else{
				$str = $a;
				$dex = 0;
				$agil = 0;
				$int = 0;
				$conc = 0;
				$contra = 0;
			}
		}
		if ($chartype == 3) {
			if($a>=4){
				$perstat = $a/4;
				$perstat = int($perstat);
				$str = 0;
				$dex = $perstat;
				$agil = 0;
				$int = $perstat*2;
				$conc = $perstat;
				$contra = 0;
			}else{
				$str = 0;
				$dex = 0;
				$agil = 0;
				$int = $a;
				$conc = 0;
				$contra = 0;
			}
		}
		if ($chartype == 4) {
			if($a>=3){
				$perstat = $a/3;
				$perstat = int($perstat);
				$str = $perstat*2;
				$dex = $perstat;
				$agil = 0;
				$int = 0;
				$conc = 0;
				$contra = 0;
			}else{
				$str = $a;
				$dex = 0;
				$agil = 0;
				$int = 0;
				$conc = 0;
				$contra = 0;
			}
		}		
		if ($chartype == 5) {
			if($a>=3){
				$perstat = $a/3;
				$perstat = int($perstat);
				$str = 0;
				$dex = 0;
				$agil = 0;
				$int = $perstat*2;
				$conc = $perstat;
				$contra = 0;
			}else{
				$str = 0;
				$dex = 0;
				$agil = 0;
				$int = $a;
				$conc = 0;
				$contra = 0;
			}

		}
		if ($chartype == 6) {
			if($a>=17){
				$perstat = $a/17;
				$perstat = int($perstat);
				$str = $perstat*3;
				$dex = $perstat*4;
				$agil = 0;
				$int = 0;
				$conc = 0;
				$contra = $perstat*10;
			}else{
				$str = $a;
				$dex = 0;
				$agil = 0;
				$int = 0;
				$conc = 0;
				$contra = 0;
			}
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
	$mech->form_number(1);
	$mech->field("Strength", $str);
	$mech->field("Dexterity", $dex);
	$mech->field("Agility", $agil);
	$mech->field("Intelligence", $int);
	$mech->field("Concentration", $conc);
	$mech->field("Contravention", $contra);
	sleep(1);
	$mech->click_button('value' => 'Level Up!!!');
	$a = $mech->content();
	$b = $mech->content();
	$c = $mech->content();
	$b =~ m/(Level : .*.<\/td> <td valign=top>Exp : )/s;
	$b = $1;
	$b =~ s/Level : //;
	$b =~ s/.<\/td> <td valign=top>Exp : //;
	$b =~ s/,//g;
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
		if($str>=1){print "[Level : $FormatedLev] You Auto-Leveled ".$forstr ." Strength\n\n";}
		if($dex>=1){print "[Level : $FormatedLev] You Auto-Leveled ".$fordex ." Dexterity\n\n";}
		if($agil>=1){print "[Level : $FormatedLev] You Auto-Leveled ".$foragil ." Agility\n\n";}
		if($int>=1){print "[Level : $FormatedLev] You Auto-Leveled ".$forint ." Intelligence\n\n";}
		if($conc>=1){print "[Level : $FormatedLev] You Auto-Leveled ".$forconc ." Concentration\n\n";}
		if($contra>=1){print "[Level : $FormatedLev] You Auto-Leveled ".$forcontra ." Contravention\n\n";}
		&TestShop;
	}else{
		print "Did not auto level.\n";
	}
	}else{
		print"Not enough exp to level \n\n";
	}
	
	if($ActualLevel >= $maxlev){
		goto START;
	}
	sleep(1);
}

sub CheckShop{
		$parsed = 0; 
	while ($parsed == 0){
		sleep(1);
		$mech->get("https://www.kingsofkingdoms.com".$URLSERVER."shop.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
			($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		}else{
			sleep(5);
			goto RESTART;
		}
	}
		my $a1;
	$a1 = $a;
	$a1 =~ s/(.*)(shopping)//si; #remove before
	$a1 =~ s/Buy upgrades!.*//s; #remove after
	$a1 =~ s/maxlength//sgi;
	$a1 =~ s/\(//sg;
	$a1 =~ s/\)//sg;
	$a1 =~ s/maxed/fullshop/sgi;
	$a1 =~ s/\s//sg;
	$a1 =~ s/\n//sgi;
	$a1 =~ s/<\/th>//sgi;
	$a1 =~ s/<\/tr>//sgi;
	$a1 =~ s/<\/td>//sgi;
	$a1 =~ s/<tr>//sgi;
	$a1 =~ s/<td>//sgi;
	$a1 =~ s/width/1/si;
	$a1 =~ s/width/2/si;
	$a1 =~ s/width/3/si;
	$a1 =~ s/width/4/si;
	$a1 =~ s/width/5/si;
	$a1 =~ s/width/6/si;
	$a1 =~ s/width/7/si;
	$a1 =~ s/width/8/si;
	$a1 =~ s/width/9/si;
	$a1 =~ s/width/a/si;
	$a1 =~ s/width/b/si;
	$a1 =~ s/width/c/si;
	my $max;
	my $aweap;
	my $aas;
	my $ahs;
	my $ahelm;
	my $ashield;
	my $aamulet;
	my $aring;
	my $aarm;
	my $abelt;
	my $apants;
	my $ahand;
	my $afeet;
	
	#open(FILE, ">$filefix shops.txt")
	#or die "failed to open file!!!!";
	#print FILE "$a1\n";
	#close(FILE);
		
	$max = $a1;
	$aweap = $a1;
	$aas = $a1;
	$ahs = $a1;
	$ahelm = $a1;
	$ashield = $a1;
	$aamulet = $a1;
	$aring = $a1;
	$aarm = $a1;
	$abelt = $a1;
	$apants = $a1;
	$ahand = $a1;
	$afeet = $a1;
	#Max
		$max =~ s/(.*)(max)//si; #remove before
		$max =~ s/price.*//si; #remove after
		$SHOPMAX = $max;
		$max =~ s/,//sg;
	#Weapon
		$aweap =~ s/td1.*//si; #remove after
		$aweap =~ s/(.*)(weapon)//si; #remove before
		$aweap =~ s/\$.*//si; #remove after
		$SHOPWEAP = $aweap;
		$aweap =~ s/,//sg;
		if($aweap >= $max){
			$shop1 = 1;
			$aweap = "Maxed";
		}else{
			$shop1 = 0;
		}
	#AttackSpell
		$aas =~ s/(.*)(^td1)//si; #remove before
		$aas =~ s/td2.*//si; #remove after
		$aas =~ s/(.*)(attackspell)//si; #remove before
		$aas =~ s/\$.*//si; #remove after
		$SHOPAS = $aas;
		$aas =~ s/,//sg;
		if($aas >= $max){
			$shop2 = 1;
			$aas = "Maxed";
		}else{
			$shop2 = 0;
		}
	#HealSpell
		$ahs =~ s/(.*)(td2)//si; #remove before
		$ahs =~ s/td3.*//si; #remove after
		$ahs =~ s/(.*)(healspell)//si; #remove before
		$ahs =~ s/\$.*//si; #remove after
		$SHOPHS = $ahs;
		$ahs =~ s/,//sg;
		if($ahs >= $max){
			$shop3 = 1;
			$ahs = "Maxed";
		}else{
			$shop3 = 0;
		}
	#Helmet
		$ahelm =~ s/(.*)(td3)//si; #remove before
		$ahelm =~ s/td4.*//si; #remove after
		$ahelm =~ s/(.*)(helmet)//si; #remove before
		$ahelm =~ s/\$.*//si; #remove after
		$SHOPHELM = $ahelm;
		$ahelm =~ s/,//sg;
		if($ahelm >= $max){
			$shop4 = 1;
			$ahelm = "Maxed";
		}else{
			$shop4 = 0;
		}
	#Shield
		$ashield =~ s/(.*)(td4)//si; #remove before
		$ashield =~ s/td5.*//si; #remove after
		$ashield =~ s/(.*)(shield)//si; #remove before
		$ashield =~ s/\$.*//si; #remove after
		$SHOPSHIELD = $ashield;
		$ashield =~ s/,//sg;
		if($ashield >= $max){
			$shop5 = 1;
			$ashield = "Maxed";
		}else{
			$shop5 = 0;
		}
	#Amulet
		$aamulet =~ s/(.*)(td5)//si; #remove before
		$aamulet =~ s/td6.*//si; #remove after
		$aamulet =~ s/(.*)(amulet)//si; #remove before
		$aamulet =~ s/\$.*//si; #remove after
		$SHOPAMULET = $aamulet;
		$aamulet =~ s/,//sg;
		if($aamulet >= $max){
			$shop6 = 1;
			$aamulet = "Maxed";
		}else{
			$shop6 = 0;
		}
	#Ring
		$aring =~ s/(.*)(td6)//si; #remove before
		$aring =~ s/td7.*//si; #remove after
		$aring =~ s/(.*)(ring)//si; #remove before
		$aring =~ s/\$.*//si; #remove after
		$SHOPRING = $aring;
		$aring =~ s/,//sg;
		if($aring >= $max){
			$shop7 = 1;
			$aring = "Maxed";
		}else{
			$shop7 = 0;
		}
	#Armor
		$aarm =~ s/(.*)(td7)//si; #remove before
		$aarm =~ s/td8.*//si; #remove after
		$aarm =~ s/(.*)(armor)//si; #remove before
		$aarm =~ s/\$.*//si; #remove after
		$SHOPARMOR = $aarm;
		$aarm =~ s/,//sg;
		if($aarm >= $max){
			$shop8 = 1;
			$aarm = "Maxed";
		}else{
			$shop8 = 0;
		}
	#Belt
		$abelt =~ s/(.*)(td8)//si; #remove before
		$abelt =~ s/td9.*//si; #remove after
		$abelt =~ s/(.*)(belt)//si; #remove before
		$abelt =~ s/\$.*//si; #remove after
		$SHOPBELT = $abelt;
		$abelt =~ s/,//sg;
		if($abelt >= $max){
			$shop9 = 1;
			$abelt = "Maxed";
		}else{
			$shop9 = 0;
		}
	#Pants
		$apants =~ s/(.*)(td9)//si; #remove before
		$apants =~ s/tda.*//si; #remove after
		$apants =~ s/(.*)(pants)//si; #remove before
		$apants =~ s/\$.*//si; #remove after
		$SHOPPANTS = $apants;
		$apants =~ s/,//sg;
		if($apants >= $max){
			$shop10 = 1;
			$apants = "Maxed";
		}else{
			$shop10 = 0;
		}
	#Hand
		$ahand =~ s/(.*)(tda)//si; #remove before
		$ahand =~ s/tdb.*//si; #remove after
		$ahand =~ s/(.*)(hand)//si; #remove before
		$ahand =~ s/\$.*//si; #remove after
		$SHOPHAND = $ahand;
		$ahand =~ s/,//sg;
		if($ahand >= $max){
			$shop11 = 1;
			$ahand = "Maxed";
		}else{
			$shop11 = 0;
		}
	#Feet
		$afeet =~ s/(.*)(tdb)//si; #remove before
		$afeet =~ s/tdc.*//si; #remove after
		$afeet =~ s/(.*)(feet)//si; #remove before
		$afeet =~ s/\$.*//si; #remove after
		$SHOPFEET = $afeet;
		$afeet =~ s/,//sg;
		if($afeet >= $max){
			$shop12 = 1;
			$afeet = "Maxed";
		}else{
			$shop12 = 0;
		}

	#print "your maximum shop is             :$max\n";
	#print "your current Weapon shop is      :$aweap\n";
	#print "your current Attackspell shop is :$aas\n";
	#print "your current Healspell shop is   :$ahs\n";
	#print "your current Helmet shop is      :$ahelm\n";
	#print "your current Shield shop is      :$ashield\n";
	#print "your current Amulet shop is      :$aamulet\n";
	#print "your current Ring shops is       :$aring\n";
	#print "your current Armor shops is      :$aarm\n";
	#print "your current Belt shops is       :$abelt\n";
	#print "your current Pants shops is      :$apants\n";
	#print "your current Hand shops is       :$ahand\n";	
	#print "your current Feet shops is       :$afeet\n";
	
}

sub TestShop{
		$parsed = 0; 
	while (!$parsed){
		sleep(1);
		$mech->get("https://www.kingsofkingdoms.com".$URLSERVER."shop.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
			($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		}else{
			sleep(5);
			goto RESTART;
		}
	}
	my $a1;
	$a1 = $a;
	$a1 =~ s/(.*)(shopping)//si; #remove before
	$a1 =~ s/Buy upgrades!.*//s; #remove after
	$a1 =~ s/maxlength//sgi;
	$a1 =~ s/\(//sg;
	$a1 =~ s/\)//sg;
	$a1 =~ s/maxed/fullshop/sgi;
	$a1 =~ s/\s//sg;
	$a1 =~ s/\n//sgi;
	$a1 =~ s/<\/th>//sgi;
	$a1 =~ s/<\/tr>//sgi;
	$a1 =~ s/<\/td>//sgi;
	$a1 =~ s/<tr>//sgi;
	$a1 =~ s/<td>//sgi;
	$a1 =~ s/width/1/si;
	$a1 =~ s/width/2/si;
	$a1 =~ s/width/3/si;
	$a1 =~ s/width/4/si;
	$a1 =~ s/width/5/si;
	$a1 =~ s/width/6/si;
	$a1 =~ s/width/7/si;
	$a1 =~ s/width/8/si;
	$a1 =~ s/width/9/si;
	$a1 =~ s/width/a/si;
	$a1 =~ s/width/b/si;
	$a1 =~ s/width/c/si;
	my $max;
	my $aweap;
	my $aas;
	my $ahs;
	my $ahelm;
	my $ashield;
	my $aamulet;
	my $aring;
	my $aarm;
	my $abelt;
	my $apants;
	my $ahand;
	my $afeet;
	
	#open(FILE, ">shops.txt")
	#or die "failed to open file!!!!";
	#print FILE "$a1\n";
	#close(FILE);
		
	$max = $a1;
	$aweap = $a1;
	$aas = $a1;
	$ahs = $a1;
	$ahelm = $a1;
	$ashield = $a1;
	$aamulet = $a1;
	$aring = $a1;
	$aarm = $a1;
	$abelt = $a1;
	$apants = $a1;
	$ahand = $a1;
	$afeet = $a1;
	#Max
		$max =~ s/(.*)(max)//si; #remove before
		$max =~ s/price.*//si; #remove after
		$max =~ s/,//sg;
	#Weapon
		$aweap =~ s/td1.*//si; #remove after
		$aweap =~ s/(.*)(weapon)//si; #remove before
		$aweap =~ s/\$.*//si; #remove after
		$aweap =~ s/,//sg;
		if($aweap >= $max){
			$shop1 = 1;
			$aweap = "Maxed";
		}else{
			$shop1 = 0;
		}
	#AttackSpell
		$aas =~ s/(.*)(^td1)//si; #remove before
		$aas =~ s/td2.*//si; #remove after
		$aas =~ s/(.*)(attackspell)//si; #remove before
		$aas =~ s/\$.*//si; #remove after
		$aas =~ s/,//sg;
		if($aas >= $max){
			$shop2 = 1;
			$aas = "Maxed";
		}else{
			$shop2 = 0;
		}
	#HealSpell
		$ahs =~ s/(.*)(td2)//si; #remove before
		$ahs =~ s/td3.*//si; #remove after
		$ahs =~ s/(.*)(healspell)//si; #remove before
		$ahs =~ s/\$.*//si; #remove after
		$ahs =~ s/,//sg;
		if($ahs >= $max){
			$shop3 = 1;
			$ahs = "Maxed";
		}else{
			$shop3 = 0;
		}
	#Helmet
		$ahelm =~ s/(.*)(td3)//si; #remove before
		$ahelm =~ s/td4.*//si; #remove after
		$ahelm =~ s/(.*)(helmet)//si; #remove before
		$ahelm =~ s/\$.*//si; #remove after
		$ahelm =~ s/,//sg;
		if($ahelm >= $max){
			$shop4 = 1;
			$ahelm = "Maxed";
		}else{
			$shop4 = 0;
		}
	#Shield
		$ashield =~ s/(.*)(td4)//si; #remove before
		$ashield =~ s/td5.*//si; #remove after
		$ashield =~ s/(.*)(shield)//si; #remove before
		$ashield =~ s/\$.*//si; #remove after
		$ashield =~ s/,//sg;
		if($ashield >= $max){
			$shop5 = 1;
			$ashield = "Maxed";
		}else{
			$shop5 = 0;
		}
	#Amulet
		$aamulet =~ s/(.*)(td5)//si; #remove before
		$aamulet =~ s/td6.*//si; #remove after
		$aamulet =~ s/(.*)(amulet)//si; #remove before
		$aamulet =~ s/\$.*//si; #remove after
		$aamulet =~ s/,//sg;
		if($aamulet >= $max){
			$shop6 = 1;
			$aamulet = "Maxed";
		}else{
			$shop6 = 0;
		}
	#Ring
		$aring =~ s/(.*)(td6)//si; #remove before
		$aring =~ s/td7.*//si; #remove after
		$aring =~ s/(.*)(ring)//si; #remove before
		$aring =~ s/\$.*//si; #remove after
		$aring =~ s/,//sg;
		if($aring >= $max){
			$shop7 = 1;
			$aring = "Maxed";
		}else{
			$shop7 = 0;
		}
	#Armor
		$aarm =~ s/(.*)(td7)//si; #remove before
		$aarm =~ s/td8.*//si; #remove after
		$aarm =~ s/(.*)(armor)//si; #remove before
		$aarm =~ s/\$.*//si; #remove after
		$aarm =~ s/,//sg;
		if($aarm >= $max){
			$shop8 = 1;
			$aarm = "Maxed";
		}else{
			$shop8 = 0;
		}
	#Belt
		$abelt =~ s/(.*)(td8)//si; #remove before
		$abelt =~ s/td9.*//si; #remove after
		$abelt =~ s/(.*)(belt)//si; #remove before
		$abelt =~ s/\$.*//si; #remove after
		$abelt =~ s/,//sg;
		if($abelt >= $max){
			$shop9 = 1;
			$abelt = "Maxed";
		}else{
			$shop9 = 0;
		}
	#Pants
		$apants =~ s/(.*)(td9)//si; #remove before
		$apants =~ s/tda.*//si; #remove after
		$apants =~ s/(.*)(pants)//si; #remove before
		$apants =~ s/\$.*//si; #remove after
		$apants =~ s/,//sg;
		if($apants >= $max){
			$shop10 = 1;
			$apants = "Maxed";
		}else{
			$shop10 = 0;
		}
	#Hand
		$ahand =~ s/(.*)(tda)//si; #remove before
		$ahand =~ s/tdb.*//si; #remove after
		$ahand =~ s/(.*)(hand)//si; #remove before
		$ahand =~ s/\$.*//si; #remove after
		$ahand =~ s/,//sg;
		if($ahand >= $max){
			$shop11 = 1;
			$ahand = "Maxed";
		}else{
			$shop11 = 0;
		}
	#Feet
		$afeet =~ s/(.*)(tdb)//si; #remove before
		$afeet =~ s/tdc.*//si; #remove after
		$afeet =~ s/(.*)(feet)//si; #remove before
		$afeet =~ s/\$.*//si; #remove after
		$afeet =~ s/,//sg;
		if($afeet >= $max){
			$shop12 = 1;
			$afeet = "Maxed";
		}else{
			$shop12 = 0;
		}

	#print "your maximum shop is             :$max\n";
	#print "your current Weapon shop is      :$aweap\n";
	#print "your current Attackspell shop is :$aas\n";
	#print "your current Healspell shop is   :$ahs\n";
	#print "your current Helmet shop is      :$ahelm\n";
	#print "your current Shield shop is      :$ashield\n";
	#print "your current Amulet shop is      :$aamulet\n";
	#print "your current Ring shops is       :$aring\n";
	#print "your current Armor shops is      :$aarm\n";
	#print "your current Belt shops is       :$abelt\n";
	#print "your current Pants shops is      :$apants\n";
	#print "your current Hand shops is       :$ahand\n";	
	#print "your current Feet shops is       :$afeet\n";

	if($shopyesno == 1){
		&BuyUpgrades;
	}elsif(($shopyesno == 1) && ($maxlev <= $MyLev)){
		&BuyUpgrades;
	}else{
		print "Shops were not bought this time\n";
	}
}
	
sub BuyUpgrades{
	$parsed = 0; 
	while (!$parsed){
		sleep(1);
		$mech->get("https://www.kingsofkingdoms.com".$URLSERVER."shop.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
			($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		}else{
			sleep(5);
			goto RESTART;
		}
	}
	
	$mech->form_number(1);

	my $maxshop = "9e99";
	
	if($chartype == 1){
		if($shop2 == 0){
			$mech->field("Attackspell", $maxshop);
		}
		if($shop4 == 0){
			$mech->field("Helmet", $maxshop);
		}
		if($shop5 == 0){
			$mech->field("Shield", $maxshop);
		}
		if($shop6 == 0){
			$mech->field("Amulet", $maxshop);
		}
		if($shop7 == 0){
			$mech->field("Ring", $maxshop);	
		}
		if($shop8 == 0){
			$mech->field("Armor", $maxshop);
		}
		if($shop9 == 0){
			$mech->field("Belt", $maxshop);
		}
		if($shop10 == 0){
			$mech->field("Pants", $maxshop);
		}
		if($shop11 == 0){
			$mech->field("Hand", $maxshop);
		}
		if($shop12 == 0){
			$mech->field("Feet", $maxshop);
		}
			$mech->click_button('value' => 'Buy upgrades!');
			$a = $mech->content();
		if ($a =~ m/Total/){
			$a =~ m/(Buy.*gold\.)/s;
			$a = $1;
			$a =~ s/<br>/\n/sg;
			print "you maxed some shops: \n". $a ."\n";
		}
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
		}
	}elsif($chartype == 2){
		if($shop1 == 0){
			$mech->field("Weapon", $maxshop);
		}
		if($shop9 == 0){
			$mech->field("Belt", $maxshop);
		}
		if($shop11 == 0){
			$mech->field("Hand", $maxshop);
		}
		if($shop12 == 0){
			$mech->field("Feet", $maxshop);
		}
			$mech->click_button('value' => 'Buy upgrades!');
			$a = $mech->content();
		if ($a =~ m/Total/){
			$a =~ m/(Buy.*gold\.)/s;
			$a = $1;
			$a =~ s/<br>/\n/sg;
			print "you maxed some shops: \n". $a ."\n";
		}
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
		}
	}elsif($chartype == 3){
		if($shop2 == 0){
			$mech->field("Attackspell", $maxshop);
		}
		if($shop7 == 0){
			$mech->field("Ring", $maxshop);	
		}
		if($shop9 == 0){
			$mech->field("Belt", $maxshop);
		}
		if($shop12 == 0){
			$mech->field("Feet", $maxshop);
		}
			$mech->click_button('value' => 'Buy upgrades!');
			$a = $mech->content();
		if ($a =~ m/Total/){
			$a =~ m/(Buy.*gold\.)/s;
			$a = $1;
			$a =~ s/<br>/\n/sg;
			print "you maxed some shops: \n". $a ."\n";
		}
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
		}
	}elsif($chartype == 4){
		if($shop1 == 0){
			$mech->field("Weapon", $maxshop);
		}
		if($shop11 == 0){
			$mech->field("Hand", $maxshop);
		}
		if($shop12 == 0){
			$mech->field("Feet", $maxshop);
		}
			$mech->click_button('value' => 'Buy upgrades!');
			$a = $mech->content();
		if ($a =~ m/Total/){
			$a =~ m/(Buy.*gold\.)/s;
			$a = $1;
			$a =~ s/<br>/\n/sg;
			print "you maxed some shops: \n". $a ."\n";
		}
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
		}
	}elsif($chartype == 5){
		if($shop2 == 0){
			$mech->field("Attackspell", $maxshop);
		}
		if($shop7 == 0){
			$mech->field("Ring", $maxshop);	
		}
		if($shop9 == 0){
			$mech->field("Belt", $maxshop);
		}
			$mech->click_button('value' => 'Buy upgrades!');
			$a = $mech->content();
		if ($a =~ m/Total/){
			$a =~ m/(Buy.*gold\.)/s;
			$a = $1;
			$a =~ s/<br>/\n/sg;
			print "you maxed some shops: \n". $a ."\n";
		}
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
		}
	}elsif($chartype == 6){
		if($shop1 == 0){
			$mech->field("Weapon", $maxshop);
		}
		if($shop6 == 0){
			$mech->field("Amulet", $maxshop);
		}
		if($shop7 == 0){
			$mech->field("Ring", $maxshop);	
		}
		if($shop11 == 0){
			$mech->field("Hand", $maxshop);
		}
		if($shop12 == 0){
			$mech->field("Feet", $maxshop);
		}
			$mech->click_button('value' => 'Buy upgrades!');
			$a = $mech->content();
		if ($a =~ m/Total/){
			$a =~ m/(Buy.*gold\.)/s;
			$a = $1;
			$a =~ s/<br>/\n/sg;
			print "you maxed some shops: \n". $a ."\n";
		}
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
		}
	}
	if($LevFinish == 1){
		$Shopped = 1;
	}
	sleep(1);
	goto START;
}

sub MyLevel{
	$parsed = 0; 
	while (!$parsed){
		sleep(1);
		$mech->get("https://www.kingsofkingdoms.com".$URLSERVER."main.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
			($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		}else{
			sleep(5);
			goto RESTART;
		}
	}

	$a = $mech->content();
	$a =~ m/(Level : .*.<\/td> <td valign=top>Exp : )/s;
	$a = $1;
	$a =~ s/Level : //;
	$a =~ s/.<\/td> <td valign=top>Exp : //;
	$a =~ s/,//g;
	$MyLev = new Math::BigFloat $a;
	$Forlev = $a;
	while($Forlev =~ m/([0-9]{4})/){
		my $temp1 = reverse $Forlev;
		$temp1 =~ s/(?<=(\d\d\d))(?=(\d))/,/;
		$Forlev = reverse $temp1;
	}
	print "Your Level is : $Forlev\n";
	#print "MyLev = $MyLev \n\n"."Current exp = $ExPCurrent \n\n"."Required exp = $ReqExp \n\n";
	if(($MyLev >= 80) && ($ExPCurrent <= $ReqExp)){
		&Acceptchall;
	}
	if($maxlev <= $MyLev){
		$LevFinish = 1;
		&TestShop;
	}
}	

sub Acceptchall{
	$parsed = 0;
	while ($parsed == 0){
		sleep(1);
		$mech->get("https://www.kingsofkingdoms.com".$URLSERVER."schedule.php");
		$a = $mech->content();
		$b = $mech->content();
		$c = $mech->content();
		if ($a =~ m/Parsed/){
			$parsed = 1;
			($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		}else{
			sleep(10);
			goto RESTART;
		}
	}
	$b =~ m/(Duel schedule.*your opponent.)/s;
	$b = $1;

	if($a =~ m/Nothing scheduled/){
		$noaction = 1;
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		print"[$Hour:$Minute:$Second]: No Duel - Reloading\n";
	}
	if($a =~m/You have been jailed for violating our rules/){
		$noaction = 1;
		print"Jailed, sleeping for 5 seconds\n";
		sleep(5);
	}
	if($a =~m/Username/){
		$noaction = 1;
		print"You have been Logged Out! Logging back in.\n";
		goto START;
	}
	if($b =~ m/($Chall*.*Accept)/si){
		$b = $1;
		$b =~ m/(href=".*Accept)/s;
		$b = $1;
		$b =~ s/\">//g;
		$b =~ s/Accept//;
		$b =~ s/href="//;
		$noaction = 1;
		sleep (1);
		$mech->get("https://www.kingsofkingdoms.com".$URLSERVER."schedule.php" . $b);
		$a = $mech->content();
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		if ($a =~ m/(You have.*slain.*xp )/s){
			$temp1 = $1;
			$temp1 =~ s/(<br>.*<br>)//s;
			print "[$Hour:$Minute:$Second]: " . $temp1 . "\n";
			&TestShop;
		}	
	}
	if($noaction == 0){
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		print"[$Hour:$Minute:$Second]: No valid challenges\n";
		goto START;
	}
	goto START;
}

sub Expcalc{
	$parsed = 0; 
	while (!$parsed){
		sleep(1);
		$mech->get("https://www.kingsofkingdoms.com/m3calculator.php");
		$a = $mech->content();
		if($a =~ m/Level Calculator/i){
			$parsed = 1;
			($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		}else{
			sleep(5);
			goto RESTART;
		}
	}

		$mech->form_number(0);
		$mech->field("exptolevel", $maxlev);
		$mech->click_button('value' => 'Calculateexp');
		$a = $mech->content();

		$a =~ m/(equals .* Exp)/s;
		$a = $1;
		$a =~ s/equals <br>//g;
		$a =~ s/ Exp//g;
		$a =~ s/,//g;
		$ReqExp = $a;
}

sub Charname{
	$parsed = 0; 
	while (!$parsed){
		sleep(1);
		$mech->get("https://www.kingsofkingdoms.com".$URLSERVER."stats.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
			($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		}else{
			sleep(5);
			goto RESTART;
		}
	}
		$a = $mech->content();
		$b = $mech->content();
		$c = $mech->content();
		$a =~ s/(.*)(natural)//si; #remove before
		$a =~ s/th.*//si; #remove after
		$a =~ s/<\///si;
		$a =~ s/(.*)(for)//si; #remove before
		$charname = $a;
		$charname =~ m/(\w+)\s+(\w+)/;
		$title = $1;
		$name = $2;
		$title =~ s/ //sgi;
		$name =~ s/ //sgi;
		#print "\nSuccessfully logged into $title $name at $Hour:$Minute:$Second\n\n";
		
		$c =~ m/(Exp :.*Gold)/;
		$c = $1;
		$c =~ s/<.*//si; #remove after
		$c =~ s/\D//gi;
		$ExPCurrent = new Math::BigFloat $c;
}

#---------------------
# MAIN
#---------------------

# create a new browser

$mech = WWW::Mechanize->new(autocheck => 0, stack_depth => 0, onerror => \&Carp::croak);
$mech->agent_alias( 'Windows Mozilla' );

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
	open(LOGINS, "m3mergers.txt")
		or die "failed to open Logins file!!!!";
		@logins = <LOGINS>;
	close(LOGINS);
	print$#logins;
if ($trigger == 1){
	if($#logins>2){
		if ($ARGV[1] >= 1 && $ARGV[1] <= 999999){
			my $logintakeone = $username-1;
			@users = split(/ /, $logins[$logintakeone]);
			$username = $users[0];
			$password = $users[1];
			chomp ($username, $password);
		}
	}else{
		print"No loggins found\n";
	}
}

$parsed = 0; 
while ($parsed == 0){
sleep(1);
$mech->get("https://www.kingsofkingdoms.com".$URLSERVER."login.php");
$a = $mech->content();
	if($a =~ m/Enter Lol!/){
		$parsed = 1;
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
	}else{
		sleep(10);
		goto RESTART;
	}
}
if($a =~ m/Username/){
	$mech->form_number(0);
	$mech->field("Username", $username);
	$mech->field("Password", $password);
	$mech->click_button('value' => 'Enter Lol!');
	($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
	#print "[$Hour:$Minute:$Second] - logged in Successfully to : \n";
}else{
	sleep(5);
	goto RESTART;
}

	my $goodlogin = $mech->content();
	if($goodlogin =~ m/\"lol_main\" src=\"https:\/\/www.kingsofkingdoms.com\/m3\/main.php\"/){	
		print"Username : ".$username.". Logged in ok at at $Hour:$Minute:$Second \n\n";
	}else{
		print"No more Logins found\n\n";
		sleep(10);
		exit();
	}

my $levels = 1;

while($levels == 1){
	START:
	($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
	if(($LevFinish == 1) && ($Shopped == 1)){
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		
		print "\nYou have reached the desired level and shopped: EXITING!!\n";
		exit();
	}
	&Expcalc;
	&Charname;
	&MyLevel;
	&CheckShop;
	&Autolevelup;
	if($MyLev <= 110){
		&Lowlevel;
		&LowFight;	
	}
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
	goto START;
}

goto START;
