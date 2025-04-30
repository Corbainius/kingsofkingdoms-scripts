#!/usr/bin/perl
use strict;
use warnings;
#print "Perl version: $^V\n";
use integer;
use Carp;
use Math::BigFloat;
use Math::BigInt;
use Time::HiRes qw(sleep);
use WWW::Mechanize;
use POSIX qw(strftime);
use feature 'try';
use Cwd qw();

#sub divide {
#    my ($numerator, $denominator) = @_;
#    return $numerator / $denominator;
#}

#my $result;
#try {
#    $result = divide(10, 0);
#}
#catch ($e) {
#   print "Caught an error: $e\n";  # This will catch the division by zero error
#};

#print "Result: $result\n";  # $result will be undef as an exception was thrown

# find and print all the links on the page
#my @links = $mech->links();
#	for my $link ( @links ) {printf "%s, %s\n", $link->text, $link->url;}

#open STDOUT, '>>', 'output.txt' or die $!;

#open STDERR, '>>', 'Errorlog.txt' or die $!;

my $trigger = 0;

if ($#ARGV+1 < 19){
	if ($ARGV[1] >= 1 && $ARGV[1] <= 999999){
		splice(@ARGV, 3, 0, ('password'));
		$trigger = 1;
	}
}	

my $debug = $ARGV[0]
or die "debug error in .bat";
my $requests = $ARGV[1]
or die "requests error in .bat";
my $username = $ARGV[2]
or die "username error in .bat";
my $password = $ARGV[3]
or die "password error in .bat";
my $stime = $ARGV[4]
or die "standard wait time in .bat";
my $loopwait = $ARGV[5]
or die "loopwait error in .bat";
my $fmode = $ARGV[6]
or die "fmode error in .bat";
my $chartype = $ARGV[7]
or die "chartype error in .bat";
my $shopyesno = $ARGV[8]
or die "Shops on or off in .bat";
my $maxlev = $ARGV[9] 
or die "maxlev error in .bat";
my $ratio0 = $ARGV[10] 
or die "maxlev error in .bat";
my $ratio1 = $ARGV[11] 
or die "maxlev error in .bat";
my $ratio2 = $ARGV[12] 
or die "maxlev error in .bat";
my $ratio3 = $ARGV[13] 
or die "maxlev error in .bat";
my $ratio4 = $ARGV[14] 
or die "maxlev error in .bat";
my $ratio5 = $ARGV[15] 
or die "maxlev error in .bat";


# Global variables
my($all, $stat);
my(@stats);
my(@logins);
my(@users);
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
my $levelnow=0;
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

if($debug == 1){print"\n Debug mode active.\n";}

if($chartype == 7 or $chartype == 8 or $chartype == 9 or $chartype == 10 or $chartype == 11 or $chartype == 12){
	print "SINGLE STAT MODE, make sure you have selected the right stat.\n";
	$Alternate = 180;
	$shopyesno = 2;
}

if($chartype == 13 or $chartype == 14){
	print "Custom Stats build mode.\n";
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

if($Month == 1){
	$MonthName = "January";
}elsif($Month == 2){
	$MonthName = "February";
}elsif($Month == 3){
	$MonthName = "March";
}elsif($Month == 4){
	$MonthName = "April";
}elsif($Month == 5){
	$MonthName = "May";
}elsif($Month == 6){
	$MonthName = "June";
}elsif($Month == 7){
	$MonthName = "July";
}elsif($Month == 8){
	$MonthName = "August";
}elsif($Month == 9){
	$MonthName = "September";
}elsif($Month == 10){
	$MonthName = "October";
}elsif($Month == 11){
	$MonthName = "November";
}elsif($Month == 12){
	$MonthName = "December";
}

$temploop = $loopwait * 10;
#---------------------

sub Lowlevel {
	$parsed = 0; 
	while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."world_control.php");
		$a = $mech->content();
		if ($a =~ m/Thief/){
		$parsed = 1;
		}else{
			sleep(10);
			goto RETRY;
		}
	}
	if($debug == 1){
		open(FILE, ">>LowLevel.txt")
		or die "failed to open file!!!!";
		print FILE "LowLevel\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		print "LowLevel\n";
	}
	$mech->form_number(1);
	$mech->click();
	$all = $mech->content();
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
	$stats[8] =~ s/,//sg;
	$stats[9] =~ s/,//sg;
	$stats[10] =~ s/,//sg;

	$wdlevel = new Math::BigFloat $stats[1];
	$aslevel = new Math::BigFloat $stats[2];
	$mslevel = new Math::BigFloat $stats[4];
	$deflevel = new Math::BigFloat $stats[5];
	$arlevel = new Math::BigFloat $stats[6];
	$mrlevel = new Math::BigFloat $stats[7];
	$sdlevel = new Math::BigFloat $stats[8];
	$sslevel = new Math::BigFloat $stats[9];
	$srlevel = new Math::BigFloat $stats[10];

	$wdlevel->bdiv('603'); 
	$aslevel->bdiv('554'); 
	$mslevel->bdiv('84'); 
	$deflevel->bdiv('42'); 
	$arlevel->bdiv('57'); 
	$mrlevel->bdiv('72');
	$sdlevel->bdiv('711');
	$sslevel->bdiv('124');
	$srlevel->bdiv('129');

	$wdlevel->bfround(1);
	$aslevel->bfround(1);
	$mslevel->bfround(1);
	$deflevel->bfround(1);
	$arlevel->bfround(1);
	$mrlevel->bfround(1);
	$sdlevel->bfround(1);
	$sslevel->bfround(1);
	$srlevel->bfround(1);

	$aslevel->bmul('2.5'); # multiplier for correct AS
	$wdlevel->bmul('2.5'); #multiplier for correct WD
	$sdlevel->bmul('2.5'); #multiplier for correct SD

	if($chartype ==4){
		$wdlevel->bdiv('2.5');
	}
	if($chartype ==5){
		$aslevel->bdiv('2.5');
	}
	if($chartype ==14){
		$sdlevel->bdiv('2.5');
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
	if($chartype == 13) {
		printf "SDlevel: %.3e", $sdlevel->bstr();
		printf ", SSlevel: %.3e", $sslevel->bstr();
		printf ", SRlevel: %.3e", $srlevel->bstr();
	}
	if($chartype == 14) {
		printf "SDlevel: %.3e", $sdlevel->bstr();
		printf ", SRlevel: %.3e", $srlevel->bstr();
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
	if ($chartype == 13) {
		$level = $sdlevel->copy();
		if ($level >= $sslevel) {$level = $sslevel->copy();}
		if ($level >= $srlevel) {$level = $srlevel->copy();}
	}
	if ($chartype == 14) {
		$level = $sdlevel->copy();
		if ($level >= $srlevel) {$level = $srlevel->copy();}
	}

	printf " --> Skeleton level: %.3e\n", $level->bstr();
	return();
}

sub LowFight {

	my($cpm);
	$parsed = 0;
	while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
		$a = $mech->content();
		if ($a =~ m/Skeleton/){
			$parsed = 1;
		}else{
			sleep(10);
			goto RETRY;
		}
	}

	print"this is low fight\n";

	if($debug == 1){
		open(FILE, ">>LowFight.txt")
		or die "failed to open file!!!!";
		print FILE "LowFight\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		print "LowFight\n";
	}
	sleep(10);
	exit();

	$mech->form_number(2);
	$mech->field("Difficulty", $level);
	$mech->click();
	$mech->click_button(value => $fmodeval);
	$a = $mech->content();
	if($debug == 1){
		open(FILE, ">>LowFight2.txt")
		or die "failed to open file!!!!";
		print FILE "LowFight2\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		print "LowFight2\n";
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
		sleep($loopwait); 
		$antal = $antal -1;
		my $retries = 0;
		retry:
		$mech->reload();
		$a = $mech->content();
		if($debug == 1){
		open(FILE, ">>LowFight3.txt")
			or die "failed to open file!!!!";
			print FILE "LowFight3\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);
			
			print "LowFight3\n";
		}
		$b = $a;
		$c = $a;
		$d = $mech->status();
		if($d == 500 or $d == 400){
			if($retries == 0){
				if($d == 400){
					print"400 error";
				}else{
					print "Trouble Connecting to internet....Probably.\n";
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
			print "ERROR - TOO HIGH MONSTER LEVEL! - you were slain!\n";exit(0);
		}
	#LOGGED OUT
		if ($a =~ m/logged/) {
			print "LOGGED OUT! sleeping for 5 seconds before restart!\n";
			sleep(5);
			goto START;
		}
		if ($antal <= 0) {
			sleep(3);
			print "Waiting last few seconds before restarting\n";
			goto START;
		}
		if ($a =~ m/(400 Bad Request)/){print"400 error restarting.";
			goto START;
		}

		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		$output = "Output was not set";
		if($b =~ m/(You win .*? exp)/){$output = $1;}
		if($b =~ m/(The battle tied.)/){$output = $1;}
		if($b =~ m/jail time.*?!/){$output = $1;}
		print "$antal: [$Hour:$Minute:$Second]: " . $output . "\n";

		$levelnow = $levelnow+1;
		$persist++;
	# level up if necessary
		if (($b =~ m/(Level up.*HERE!)/) and ($indefcont != 1) and ($persist == 10)) {
			$persist = 0;
			&Levelup; 
		}
	}
}

sub Autolevelup {
	$parsed = 0; while ($parsed == 0) {sleep($stime);
	$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."stats.php");
	$a = $mech->content();
	if ($a =~ m/Parsed/){
		$parsed = 1;
	}else{
			sleep(10);
			goto RETRY;
		}
	}
	if($debug == 1){
		open(FILE, ">>Autolevelup.txt")
		or die "failed to open file!!!!";
		print FILE "Autolevelup\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		print "Autolevelup\n";
	}
	$a = $mech->content();
	$b = $mech->content();
	
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
				print"Skipping autolevel because there are less than 100 levels to level.\n";
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
		$b = $mech->content();
		$c = $mech->content();
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
			if($str>=1){print "[Level : $FormatedLev] You Auto-Leveled ".$forstr ." Strength\n\n";}
			if($dex>=1){print "[Level : $FormatedLev] You Auto-Leveled ".$fordex ." Dexterity\n\n";}
			if($agil>=1){print "[Level : $FormatedLev] You Auto-Leveled ".$foragil ." Agility\n\n";}
			if($int>=1){print "[Level : $FormatedLev] You Auto-Leveled ".$forint ." Intelligence\n\n";}
			if($conc>=1){print "[Level : $FormatedLev] You Auto-Leveled ".$forconc ." Concentration\n\n";}
			if($contra>=1){print "[Level : $FormatedLev] You Auto-Leveled ".$forcontra ." Contravention\n\n";}
			&CheckShop;
		}else{
			print "Did not auto level.\n";
		}
	}
	return();
}

sub CPMlevel {
	$parsed = 0; 
	while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."world_control.php");
		$a = $mech->content();
		if ($a =~ m/Thief/){
		$parsed = 1;
		}else{
			sleep(10);
			goto RETRY;
		}
	}
	if($debug == 1){
		open(FILE, ">>CPMlevel.txt")
		or die "failed to open file!!!!";
		print FILE "CPMlevel\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		print "CPMlevel\n";
	}
	$mech->form_number(1);
	$mech->click();
	$all = $mech->content();
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
	$stats[3] =~ s/,//sg;
	$stats[4] =~ s/,//sg;
	$stats[5] =~ s/,//sg;
	$stats[6] =~ s/,//sg;
	$stats[7] =~ s/,//sg;
	$stats[8] =~ s/,//sg;
	$stats[9] =~ s/,//sg;
	$stats[10] =~ s/,//sg;

	$wdlevel = new Math::BigFloat $stats[1];
	$aslevel = new Math::BigFloat $stats[2];
	$mslevel = new Math::BigFloat $stats[4];
	$deflevel = new Math::BigFloat $stats[5];
	$arlevel = new Math::BigFloat $stats[6];
	$mrlevel = new Math::BigFloat $stats[7];
	$sdlevel = new Math::BigFloat $stats[8];
	$sslevel = new Math::BigFloat $stats[9];
	$srlevel = new Math::BigFloat $stats[10];

	
	$wdlevel->bdiv('1661622');
	$aslevel->bdiv('1877897');
	$mslevel->bdiv('3028631');
	$deflevel->bdiv('1817170');
	$arlevel->bdiv('363482.2');
	$mrlevel->bdiv('363497.2');
	$sdlevel->bdiv('4630062.7');
	$sslevel->bdiv('4845800.3');
	$srlevel->bdiv('726979.3');

	$wdlevel->bfround(1);
	$aslevel->bfround(1);
	$mslevel->bfround(1);
	$deflevel->bfround(1);
	$arlevel->bfround(1);
	$mrlevel->bfround(1);
	$sdlevel->bfround(1);
	$sslevel->bfround(1);
	$srlevel->bfround(1);

	$aslevel->bmul('2.5'); # multiplier for correct AS
	$wdlevel->bmul('2.5'); #multiplier for correct WD
	$sdlevel->bmul('2.5'); #multiplier for correct SD

	if($chartype ==4){
		$wdlevel->bdiv('2.5');
	}
	if($chartype ==5){
		$aslevel->bdiv('2.5');
	}
	if($chartype ==14){
		$sdlevel->bdiv('2.5');
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
	if($chartype == 13) {
			printf "SDlevel: %.3e", $sdlevel->bstr();
			printf ", SSlevel: %.3e", $sslevel->bstr();
			printf ", SRlevel: %.3e", $srlevel->bstr();
	}
	if($chartype == 14) {
			printf "SDlevel: %.3e", $sdlevel->bstr();
			printf ", SRlevel: %.3e", $srlevel->bstr();
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
	if ($chartype == 13){
		$level = $sdlevel->copy();
		if ($level >= $sslevel) {$level = $sslevel->copy();}
		if ($level >= $srlevel) {$level = $srlevel->copy();}
	}
	if ($chartype == 14) {
		$level = $sdlevel->copy();
		if ($level >= $srlevel) {$level = $srlevel->copy();}
	}

	printf " --> CPM level: %.3e\n", $level->bstr();
	return();
}

sub leveltestworld {
	if($debug == 1){
		print"Arrived at leveltestworld\n";
	}
	$parsed = 0; 
	while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."world_control.php");
		$a = $mech->content();
		if ($a =~ m/Thief/){
		$parsed = 1;
		}else{
			sleep(10);
			goto RETRY;
		}
	}

	if($debug == 1){
			print $levelfilename."\n";
	}

	my $fname = $levelfilename;
	if($debug == 1){
		print $fname."\n";
	}
	if(-e $fname){
		if($debug == 1){
			print("File $fname exists\n");
		}
		open(FILE, "<".$fname)
		or die "failed to open file!!!!";
			while (my $line = <FILE>) {
				chomp $line;
				$filelevel = $line;
			}
		close(FILE);
		
		if($debug == 1){
			print "filelevel = ".$filelevel.".\n";
		}
	}else{
		if($debug == 1){
			print("File $fname does not exists\n");
		}
		open(FILE, "+>".$fname)
		or die "failed to open file!!!!";
		print FILE "1";
		close(FILE);
		$filelevel = 1;
	}

	$won = 1;

	if(!$levmulti){$levmulti = 1;}

	while($won == 1){
		if(!$levmulti){$levmulti = 1;}else{
			$levmulti = $levmulti*10;}
		if($debug == 1){
			print "levmulti = ".$levmulti."\n";
		}
		$level = $levmulti;
		$mech->form_number(2);
		$mech->field("Difficulty", $level);
		$mech->click();
		sleep($stime);
		$a = $mech->content();
		$a =~ m/(<select name="Monster">.*<\/form><form method=post>)/s;
		$a = $1;
		$mech->click_button(value => $fmodeval);
		sleep($loopwait); 
		$b = $mech->content();
		$b =~ m/(<td valign=top>Level.*<form method=post)/s;
		$b = $1;

		open(FILE, ">>TESTINFO1.txt")
		or die "failed to open file!!!!";		
		print FILE "\nTHIS IS A\nTHIS IS A\n";
		print FILE $a;
		print FILE "\nTHIS IS B\nTHIS IS B\n";
		print FILE $b;
		print FILE "\n";
		close(FILE);
		if ($b =~ m/You win/) {
			print "You won at level ".$level."\n";
			$won = 1;
			if($debug == 1){
				print "levmulti = ".$levmulti."\n";
			}
		}		
		if ($b =~ m/battle tied/) {
			print "You tied at level ".$level."\n";
			$won = 0;
			$level = $level;
			if($debug == 1){
				print "levmulti = ".$levmulti."\n";
			}
			$tied++;
		}
		if ($b =~ m/stunned/) {
			print "You lost at level ".$level."\n";
			print "Waiting 5 seconds before continuing \n";
			$won = 0;
			$level = $level;
			if($debug == 1){
				print "levmulti = ".$levmulti."\n";
			}
			sleep(6);
		}
	}

	if($debug == 1){
		print "base level is ".$level."\n";
	}
	
	until ($setlev == 1){
		$level = $level;
		$reps = 0;
		$mech->form_number(2);
		$mech->field("Difficulty", $level);
		$mech->click();
		sleep($stime);
		$a = $mech->content();
		$a =~ m/(<select name="Monster">.*<\/form><form method=post>)/s;
		$a = $1;
		$mech->click_button(value => $fmodeval);
		sleep($loopwait); 
		$b = $mech->content();
		$b =~ m/(<td valign=top>Level.*<form method=post)/s;
		$b = $1;
		open(FILE, ">>TESTINFO2.txt")
		or die "failed to open file!!!!";		
		print FILE "\nTHIS IS A\nTHIS IS A\n";
		print FILE $a;
		print FILE "\nTHIS IS B\nTHIS IS B\n";
		print FILE $b;
		print FILE "\n";
		close(FILE);
		if ($b =~ m/You win/) {
			print "You won at level".$level."\n";
			$reps++;
		}
		if ($b =~ m/battle tied/) {
			print "You tied at level ".$level."\n";
			$reps++;
		}
		if ($b =~ m/stunned/) {
			$reps++;
			print "rep no. ".$reps." You lost at level".$level."\n";
			print "Waiting 5 seconds before continuing \n";
			sleep(6);
		}
		
		until(($won == 0)or($reps == 9)){
			sleep($loopwait); 
			$mech->reload();
			$a = $mech->content();
			$b = $a;
			open(FILE, ">>TESTINFO2.txt")
			or die "failed to open file!!!!";		
			print FILE "\nTHIS IS A\nTHIS IS A\n";
			print FILE $a;
			print FILE "\nTHIS IS B\nTHIS IS B\n";
			print FILE $b;
			print FILE "\n";
			close(FILE);
			if ($b =~ m/You win/) {
				print "You won at level".$level."\n";
				$won = 1;
				$reps++;

			}
			if ($b =~ m/battle tied/) {
				print "You tied at level ".$level."\n";
				$won = 1;
				$reps++;
			}
			if ($b =~ m/stunned/) {
				print "You lost at level".$level."\n";
				print "Waiting 5 seconds before continuing \n";
				$won = 0;
				$reps++;
				sleep(6);
			}
			if($debug == 1){
				print "reps = ".$reps."\n";
			}
			$level = $newlevel;
		}
	}


	#open(FILE, ">>CPMlevel.txt")
	#or die "failed to open file!!!!";
	#print FILE "CPMlevel\n\n";
	#print FILE "content\n\n";
	#print FILE "$a\n\n";
	#close(FILE);
	
	#print "CPMlevel\n";

	#	my $addir = "AD";
	#	my $apdir = "AP";
	#	my $spdir = "SP";

	#	my $fileend = "level.txt";
	#if($fmode == 1){		
	#	$levelfilename = "\\".$addir."\\".$name.$fileend;
	#}elsif($fmode == 2){
	#	$levelfilename = "\\".$apdir."\\".$name.$fileend;
	#}elsif($fmode == 3){
	#	$levelfilename = "\\".$spdir."\\".$name.$fileend;
	#}
	#
	#if($debug == 1){
	#	print $levelfilename."\n";
	#}
	#$levelfilename
	$level = $filelevel;
	return($level);
}

sub Fight {
	my($cpm);
	$parsed = 0;
	while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
		$a = $mech->content();
		if ($a =~ m/Skeleton/){
			$parsed = 1;
		}else{
			sleep(10);
			goto RETRY;
		}
	}
	if($debug == 1){
		open(FILE, ">>Fight.txt")
		or die "failed to open file!!!!";
		print FILE "Fight\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		print "Fight\n";
	}
	$mech->form_number(2);
	$mech->field("Difficulty", $level);
	$mech->click();
	$cpm = $mech->content();
	if($debug == 1){
		open(FILE, ">>Fightlevel.txt")
		or die "failed to open file!!!!";
		print FILE "Fightlevel\n\n";
		print FILE "$cpm\n\n";
		close(FILE);
		print "Fightlevel\n";
	}
	$cpm =~ m/(<option>208.*<\/option><option>209)/;
    $cpm = $1;
    $cpm =~ s/ - Shadowlord Duke//g;
    $cpm =~ s/\>209/\>/;
    $cpm =~ s/<.*?>//g;
	print $cpm . "\n";
	$mech->form_number(1);
	$mech->select("Monster", $cpm);
	$mech->click_button(value => $fmodeval);
	$a = $mech->content();
	if($debug == 1){
		open(FILE, ">>Fight2.txt")
		or die "failed to open file!!!!";
		print FILE "Fight2\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		print "Fight2\n";
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
		sleep($loopwait);
		$antal = $antal -1;
		my $retries = 0;
		retry:
		$mech->reload();
		$a = $mech->content();
		if($debug == 1){
			open(FILE, ">>Fight3.txt")
			or die "failed to open file!!!!";
			print FILE "Fight3\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);
			
			print "Fight3\n";
		}
		$b = $a;
		$c = $a;
		$d = $mech->status();
		if($d == 500 or $d == 400){
			if($retries == 0){
				if($d == 400){
					print"more 400 error's";
				}else{
					print "Trouble Connecting to internet....Probably.\n";
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
			print "ERROR - TOO HIGH MONSTER LEVEL! - you were slain!\n";
			exit(0);
		}
	#LOGGED OUT

		if ($a =~ m/logged/) {
			print "LOGGED OUT! sleeping for 5 seconds before restart!\n";
			sleep(5);
			goto START;
		}
		if ($antal <= 0) {
			sleep(3);
			print "Waiting last few seconds before restarting\n";
			goto START;
		}
		if ($b =~ m/(400 Bad Request)/) {print"400 error restarting.";
			goto START;
		}
		
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		$output = "Output was not set";
		if($b =~ m/(You win .*? exp)/){$output = $1;}
		if($b =~ m/(The battle tied.)/){$output = $1;}
		if($b =~ m/jail time.*?!/){$output = $1;}
		print "$antal: [$Hour:$Minute:$Second]: " . $output . "\n";

		$levelnow = $levelnow+1;
	#level up if necessary
		if (($b =~ m/(Level up.*HERE!)/) and ($indefcont != 1)) {
			&Levelup; 
		}
	}
}

sub Levelup{
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."stats.php");
		$a = $mech->content();
		if($a =~ m/<a href="stats.php/){
			sleep($stime);
			$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."stats.php");
			$a = $mech->content();
		}
		if($debug == 1){
			open(FILE, ">>Levelup.txt")
			or die "failed to open file!!!!";
			print FILE "Levelup\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);
			
			print "Levelup\n";
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
					print "You Leveled "."$numlevs1"." Intelligence\n";
					&CheckShop;
				}
				if(($deflevel <= $aslevel) && ($deflevel <= $mrlevel)) {
					$mech->form_number(1);
					$mech->field("Agility", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "You Leveled "."$numlevs1"." Agility\n";
				}

				if(($mrlevel <= $deflevel) && ($mrlevel <= $aslevel)) {
					$mech->form_number(1);
					$mech->field("Concentration", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "You Leveled "."$numlevs1"." Concentration\n";
				}
			}elsif($chartype == 2){
				if(($wdlevel <= $mrlevel) && ($wdlevel <= $arlevel)) {
					$mech->form_number(1);
					$mech->field("Strength", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "You Leveled "."$numlevs1"." Strength\n";
					&CheckShop;
				}
				if(($arlevel <= $wdlevel) && ($arlevel <= $mrlevel)) {
					$mech->form_number(1);
					$mech->field("Dexterity", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "You Leveled "."$numlevs1"." Dexterity\n";
				}

				if(($mrlevel <= $wdlevel) && ($mrlevel <= $arlevel)) {
					$mech->form_number(1);
					$mech->field("Concentration", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "You Leveled "."$numlevs1"." Concentration\n";
				}
			}elsif($chartype == 3){
				if(($aslevel <= $arlevel) && ($aslevel <= $mrlevel)) {
					$mech->form_number(1);
					$mech->field("Intelligence", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "Leveled up "."$numlevs1"." Intelligence\n";
					&CheckShop;
				}
				if(($arlevel <= $aslevel) && ($arlevel <= $mrlevel)) {
					$mech->form_number(1);
					$mech->field("Dexterity", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "Leveled up "."$numlevs1"." Dexterity\n";
				}

				if(($mrlevel <= $arlevel) && ($mrlevel <= $aslevel)) {
					$mech->form_number(1);
					$mech->field("Concentration", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "Leveled up "."$numlevs1"." Concentration\n";
				}
			}elsif($chartype == 4){
				if($wdlevel <= $arlevel) {
				$mech->form_number(1);
				$mech->field("Strength", $numlevs);
				$mech->click_button('value' => 'Level Up!!!');
				print "Leveled up "."$numlevs1"." Strength\n";
				&CheckShop;
				}		
				if($arlevel <= $wdlevel) {
					$mech->form_number(1);
					$mech->field("Dexterity", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "Leveled up "."$numlevs1"." Dexterity\n";
				}
			}elsif($chartype == 5){
				if($mrlevel >= $aslevel) {
					$mech->form_number(1);	
					$mech->field("Intelligence", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "Leveled up "."$numlevs1"." Intelligence\n";
					&CheckShop;
				}

				if($aslevel >= $mrlevel) {
					$mech->form_number(1);
					$mech->field("Concentration", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "Leveled up "."$numlevs1"." Concentration\n";
				}
			}elsif($chartype == 6){
				if(($wdlevel <= $mslevel) && ($wdlevel <= $arlevel)) {
					$mech->form_number(1);
					$mech->field("Strength", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "Leveled up "."$numlevs1"." Strength\n";
					&CheckShop;
				}
				if(($mslevel <= $wdlevel) && ($mslevel <= $arlevel)) {
					$mech->form_number(1);
					$mech->field("Contravention", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "Leveled up "."$numlevs1"." Contravention\n";
				}
				if(($arlevel <= $mslevel) && ($arlevel <= $wdlevel)) {
					$mech->form_number(1);
					$mech->field("Dexterity", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "Leveled up "."$numlevs1"." Dexterity\n";
				}
			}elsif($chartype == 13 or $chartype == 14){
				if($numlevs>6){
					$mech->form_number(1);
					$mech->field("Strength", $strlevs);
					print "Leveled up "."$strlevs"." Strength\n";
					$mech->field("Dexterity", $dexlevs);
					print "Leveled up "."$dexlevs"." Dexterity\n";
					$mech->field("Agility", $agillevs);
					print "Leveled up "."$agillevs"." Agility\n";
					$mech->field("Intelligence", $intlevs);
					print "Leveled up "."$intlevs"." Intelligence\n";
					$mech->field("Concentration", $conclevs);
					print "Leveled up "."$conclevs"." Concentration\n";
					$mech->field("Contravention", $contralevs);
					print "Leveled up "."$contralevs"." Contravention\n";
					$mech->click_button('value' => 'Level Up!!!');
					&CheckShop;
				}else{
					print"Skipping levelup because there are less than 6 levels to level.\n";
					goto START;

				}
			}
		}else{
			print"Did not level, Max level reached.";
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
	}
	if($debug == 1){
		open(FILE, ">>CheckShop.txt")
		or die "failed to open file!!!!";
		print FILE "Checkshop\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);	
		print "Checkshop\n";
	}

	if($shopyesno == 1){
		&MaxShops;
	}else{
		print "Shops were not bought this time\n";
	}
}

sub MaxShops{
	$parsed = 0; 
	while (!$parsed){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."shop.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
		}
	}
	if($debug == 1){
				open(FILE, ">>MaxShops.txt")
				or die "failed to open file!!!!";
				print FILE "MaxShops\n\n";
				print FILE "content\n\n";
				print FILE "$a\n\n";
				close(FILE);
				print "MaxShops\n";
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
	goto GOTO;
}

sub MaxWD{	
	$Sname = "Weapon";
    my ($shop1) = @_;
	if($$shop1 =~ "Maxed"){$proceed = 0;print $Sname." Maxed\n";}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(1);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
		$b = $a;			
		if($debug == 1){
			open(FILE, ">MaxWD.txt")
			or die "failed to open file!!!!";
			print FILE "MaxWD\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			print "MaxWD\n";
		}
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			print "$a\n";
		}
		$b =~ m/(<td>Weapon<\/td>.*?<\/form>)/s;
		$b = $1;
		if($b =~ "Maxed"){$proceed = 0; print $Sname." shops Maxed.\n";}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxAS{	
	$Sname = "Attackspell";
    my ($shop2) = @_;
	if($$shop2 =~ "Maxed"){$proceed = 0;print $Sname." Maxed\n";}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(2);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
		$b = $a;
			if($debug == 1){
				open(FILE, ">MaxAS.txt")
				or die "failed to open file!!!!";
				print FILE "MaxAS\n\n";
				print FILE "content\n\n";
				print FILE "$a\n\n";
				close(FILE);
				print "MaxAS\n";
			}
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			print "$a\n";
		}
		$b =~ m/(<td>Attackspell<\/td>.*?<\/form>)/s;
		$b = $1;
		if($b =~ "Maxed"){$proceed = 0; print $Sname." shops Maxed.\n";}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxHS{
	$Sname = "Healspell";
    my ($shop3) = @_;
	if($$shop3 =~ "Maxed"){$proceed = 0;print $Sname." Maxed\n";}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(3);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
		$b = $a;
		if($debug == 1){
			open(FILE, ">MaxHS.txt")
			or die "failed to open file!!!!";
			print FILE "MaxHS\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);
			
			print "MaxHS\n";
		}
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			print "$a\n";
		}
		$b =~ m/(<td>Healspell<\/td>.*?<\/form>)/s;
		$b = $1;
		if($b =~ "Maxed"){$proceed = 0; print $Sname." shops Maxed.\n";}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxHE{
	$Sname = "Helmet";
    my ($shop4) = @_;
	if($$shop4 =~ "Maxed"){$proceed = 0;print $Sname." Maxed\n";}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(4);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
		$b = $a;		
		if($debug == 1){
			open(FILE, ">MaxHE.txt")
			or die "failed to open file!!!!";
			print FILE "MaxHE\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);
			print "MaxHE\n";
		}		
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			print "$a\n";
		}
		$b =~ m/(<td>Helmet<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; print $Sname." shops Maxed.\n";}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxSH{
	$Sname = "Shield";
    my ($shop5) = @_;
	if($$shop5 =~ "Maxed"){$proceed = 0;print $Sname." Maxed\n";}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(5);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
		$b = $a;
		if($debug == 1){
			open(FILE, ">MaxSH.txt")
			or die "failed to open file!!!!";
			print FILE "MaxSH\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			print "MaxSH\n";
		}		
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			print "$a\n";
		}
		$b =~ m/(<td>Shield<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; print $Sname." shops Maxed.\n";}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxAM{		
	$Sname = "Amulet";
    my ($shop6) = @_;	
	if($$shop6 =~ "Maxed"){$proceed = 0;print $Sname." Maxed\n";}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(6);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
		$b = $a;		
		if($debug == 1){
			open(FILE, ">MaxAM.txt")
			or die "failed to open file!!!!";
			print FILE "MaxAM\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			print "MaxAM\n";
		}		
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			print "$a\n";
		}
		$b =~ m/(<td>Amulet<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; print $Sname." shops Maxed.\n";}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxRI{
	$Sname = "Ring";
    my ($shop7) = @_;
	if($$shop7 =~ "Maxed"){$proceed = 0;print $Sname." Maxed\n";}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(7);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
		$b = $a;		
		if($debug == 1){
			open(FILE, ">MaxRI.txt")
			or die "failed to open file!!!!";
			print FILE "MaxRI\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			print "MaxRI\n";
		}			
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			print "$a\n";
		}
		$b =~ m/(<td>Ring<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; print $Sname." shops Maxed.\n";}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxAR{
	$Sname = "Armor";
    my ($shop8) = @_;
	if($$shop8 =~ "Maxed"){$proceed = 0;print $Sname." Maxed\n";}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(8);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
		$b = $a;		
		if($debug == 1){
			open(FILE, ">MaxAR.txt")
			or die "failed to open file!!!!";
			print FILE "MaxAR\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			print "MaxAR\n";
		}		
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			print "$a\n";
		}
		$b =~ m/(<td>Armor<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; print $Sname." shops Maxed.\n";}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxBE{
	$Sname = "Belt";
	my ($shop9) = @_;
	if($$shop9 =~ "Maxed"){$proceed = 0;print $Sname." Maxed\n";}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(9);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
		$b = $a;		
		if($debug == 1){
			open(FILE, ">MaxBE.txt")
			or die "failed to open file!!!!";
			print FILE "MaxBE\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			print "MaxBE\n";
		}
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			print "$a\n";
		}
		$b =~ m/(<td>Belt<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; print $Sname." shops Maxed.\n";}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxPA{
	$Sname = "Pants";
    my ($shop10) = @_;
	if($$shop10 =~ "Maxed"){$proceed = 0;print $Sname." Maxed\n";}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(10);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
		$b = $a;
		if($debug == 1){
			open(FILE, ">MaxPA.txt")
			or die "failed to open file!!!!";
			print FILE "MaxPA\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			print "MaxPA\n";
		}
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			print "$a\n";
		}
		$b =~ m/(<td>Pants<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; print $Sname." shops Maxed.\n";}
	}	
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxHA{
	$Sname = "Hand";
    my ($shop11) = @_;
	if($$shop11 =~ "Maxed"){$proceed = 0;print $Sname." Maxed\n";}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(11);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
		$b = $a;
		if($debug == 1){
			open(FILE, ">MaxHA.txt")
			or die "failed to open file!!!!";
			print FILE "MaxHA\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			print "MaxHA\n";
		}
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			print "$a\n";
		}
		$b =~ m/(<td>Hand<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; print $Sname." shops Maxed.\n";}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MaxFE{	
	$Sname = "Feet";
    my ($shop12) = @_;	
	if($$shop12 =~ "Maxed"){$proceed = 0;print $Sname." Maxed\n";}else{$proceed = 1;}
	while($proceed == 1){
		$mech->form_number(12);
		$mech->click_button('name' => $Sname);
		sleep($stime);
		$a = $mech->content();
		$b = $a;
		if($debug == 1){
			open(FILE, ">MaxFE.txt")
			or die "failed to open file!!!!";
			print FILE "MaxFE\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);			
			print "MaxFE\n";
		}
		if ($a =~ m/Not enough gold!/){
			print "You did not have enough Gold in your hand to max all your shops.\n";
			return();
		}
		if ($a =~ m/Bought/){
			$a =~ m/(Bought.*gold\.<br>)/s;
			$a = $1;
			$a =~ s/<br>//sg;
			print "$a\n";
		}
		$b =~ m/(<td>Feet<\/td>.*?<\/form>)/s;
		$b = $1;		
		if($b =~ "Maxed"){$proceed = 0; print $Sname." shops Maxed.\n";}
	}
	$a = "";
	$b = "";
	$Sname = "";
	return();
}

sub MyLevel{
	$parsed = 0; 
	while (!$parsed){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."main.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
		}
	}
	if($debug == 1){
					open(FILE, ">>MyLevel.txt")
					or die "failed to open file!!!!";
					print FILE "Mylevel\n\n";
					print FILE "content\n\n";
					print FILE "$a\n\n";
					close(FILE);
					
					print "Mylevel\n";
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
	print "Your Level is : $Forlev\n";
	
	if($maxlev <= $MyLev){
		print "You have reached the desired level. Continuing without leveling\n";
	}
}	

sub Charname{
	$parsed = 0; 
	while (!$parsed){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."stats.php");
		$a = $mech->content();
		if($a =~ m/Parsed/){
			$parsed = 1;
		}
	}
	if($debug == 1){
				open(FILE, ">>Charname.txt")
				or die "failed to open file!!!!";
				print FILE "Charname\n\n";
				print FILE "content\n\n";
				print FILE "$a\n\n";
				close(FILE);
				
				print "Charname\n";
	}
	$a = $mech->content();
	$b = $mech->content();
	$c = $mech->content();
	
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
	print "\nSuccessfully logged into $title $name at $Hour:$Minute:$Second\n\n";
	
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
		print"c =".$c."\n";
	}
		$c =~ m/(a.*b)/;
			$c0 = $1;
				$c0 =~ s/[a-z]//ig;
				$c0= new Math::BigFloat $c0;
		if($debug == 1){
			print"c0 =".$c0."\n";
		}
		$c =~ m/(b.*c)/;
			$c1 = $1;
				$c1 =~ s/[a-z]//ig;
				$c1= new Math::BigFloat $c1;
		if($debug == 1){
			print"c1 =".$c1."\n";
		}
		$c =~ m/(c.*d)/;
			$c2 = $1;
				$c2 =~ s/[a-z]//ig;
				$c2= new Math::BigFloat $c2;
		if($debug == 1){
			print"c2 =".$c2."\n";
		}
		$c =~ m/(d.*e)/;
			$c3 = $1;
				$c3 =~ s/[a-z]//ig;
				$c3= new Math::BigFloat $c3;
		if($debug == 1){
			print"c3 =".$c3."\n";
		}
		$c =~ m/(e.*f)/;
			$c4 = $1;
				$c4 =~ s/[a-z]//ig;
				$c4= new Math::BigFloat $c4;
		if($debug == 1){
			print"c4 =".$c4."\n";
		}
		$c =~ m/(f.*g)/;
			$c5 = $1;
				$c5 =~ s/[a-z]//ig;
				$c5= new Math::BigFloat $c5;
		if($debug == 1){
			print"c5 =".$c5."\n";
		}
		$c =~ m/(g.*h)/;
			$c6 = $1;
				$c6 =~ s/[a-z]//ig;
				$c6= new Math::BigFloat $c6;
		if($debug == 1){
			print"c6 =".$c6."\n";
		}
		$c =~ m/(h.*i)/;
			$c7 = $1;
				$c7 =~ s/[a-z]//ig;
				$c7= new Math::BigFloat $c7;
		if($debug == 1){
			print"c7 =".$c7."\n";
		}
   		$c =~ m/(i.*j)/;
			$c8 = $1;
				$c8 =~ s/[a-z]//ig;
				$c8= new Math::BigFloat $c8;
		if($debug == 1){
			print"c8 =".$c8."\n";
		}
		$c =~ m/(j.*k)/;
			$c9 = $1;
				$c9 =~ s/[a-z]//ig;
				$c9= new Math::BigFloat $c9;
		if($debug == 1){
			print"c9 =".$c9."\n";
		}

		if(($c0 >= "731420819") or ($c1 >= "734691740") or ($c7 >= "921382475")){
			if(($c5 >= "73506388")or($c6 >= "74836787")or($c6 >= "144668877")){
				$cpmready = 1;
			}else{
				$cpmready = 0;
			}
		}else{
			$cpmready = 0;
		}
		
	my $addir = "AD";
	my $apdir = "AP";
	my $spdir = "SP";

	my $fileend = "level.txt";
	
	if($fmode == 1){		
		$levelfilename = $path."/".$addir."/".$name.$fileend;
	}elsif($fmode == 2){
		$levelfilename = $path."/".$apdir."/".$name.$fileend;
	}elsif($fmode == 3){
		$levelfilename = $path."/".$spdir."/".$name.$fileend;
	}
	
	if($debug == 1){
		print $levelfilename."\n";
	}
}

#---------------------
# MAIN
#---------------------

# create a new browser
$mech = WWW::Mechanize->new(autocheck => 0, stack_depth => 1, onerror => \&Carp::croak);
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
	print"No logins found.";
	sleep($stime);
	goto RETRY;
}
RETRY:
if($trycounter == 0){$trycounter = 1;}
print"\n\nConnection attempt ".$trycounter.".\n\n";
$parsed = 0; 
while ($parsed == 0){
sleep($stime);
$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."login.php");
$a = $mech->content();
$b = $mech->success();
$c = $mech->response();
$d = $mech->status();

				if($debug == 1){
						open(FILE, ">>Loginrecord.txt")
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

						print "login\n";
					if($requests==1){
						$mech->add_handler("request_preprepare",  sub {print"\n\n PREPREPARE \n\n"; shift->dump; return });
						$mech->add_handler("request_prepare",  sub {print"\n\n PREPARE \n\n"; shift->dump; return });
						$mech->add_handler("response_header",  sub {print"\n\n RESPONSE HEADER \n\n"; shift->dump; return });
						$mech->add_handler("request_send",  sub {print"\n\n REQUEST \n\n"; shift->dump; return });
						$mech->add_handler("response_done", sub {print"\n\n RESPONSE \n\n"; shift->dump; return });
					}
				}
print "SUCCESS: $b\nSTATUS: $d\n\n";
	if($d == 200){
		if($a =~ m/Enter Lol!/){
			$parsed = 1;
		}else{
			$parsed = 0;
			sleep(10);
			goto RETRY;
		}
	}elsif(($d == 500) || ($d == 523)){
		print "Trouble Connecting to internet....Probably\n";
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
	#print "[$Hour:$Minute:$Second] - logged in Successfully to : \n";
	if($a =~ m/Login failed/){
		print"Login failed.\n";
		sleep(30);
		goto RETRY;
	}
}else{
	sleep(5);
	goto RETRY;
}


my $levels = 9999999;

until($levels == 0){
	START:
	$levels--;
	&Charname;
	&MyLevel;
	if($avlevs > $MyLev){&Autolevelup};
	&CheckShop;
	GOTO:
	if($cpmready == 0){
		print "\nLow Level Fight mode\n\n";
	}else{
		print "\nHigh Level Fight mode\n\n";
	}
	if($cpmready == 0){
		&leveltestworld;
		#&Lowlevel;
		&LowFight;	
	}else{
		&leveltestfight;
		#&CPMlevel;
		&Fight;
	}

}

goto RETRY;