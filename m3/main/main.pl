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

# find and print all the links on the page
#my @links = $mech->links();
#	for my $link ( @links ) {printf "%s, %s\n", $link->text, $link->url;}

#open STDOUT, '>>', 'output.txt' or die $!;

#open STDERR, '>>', 'Errorlog.txt' or die $!;

my $trigger = 0;

if ($#ARGV+1 < 13){
	if ($ARGV[1] >= 1 && $ARGV[1] <= 999999){
		splice(@ARGV, 4, 0, ('password'));
		$trigger = 1;
	}
}	

my $debug = $ARGV[0]
or die "debug error in .bat";
my $requests = $ARGV[1]
or die "requests error in .bat";
my $server = $ARGV[2]
or die "Server error in .bat";
my $username = $ARGV[3]
or die "username error in .bat";
my $password = $ARGV[4]
or die "password error in .bat";
my $stime = $ARGV[5]
or die "standard wait time in .bat";
my $loopwait = $ARGV[6]
or die "loopwait error in .bat";
my $chartype = $ARGV[7]
or die "chartype error in .bat";
my $shopyesno = $ARGV[8]
or die "Shops on or off in .bat";
my $stealchar = $ARGV[9]
or die "stealername error in .bat";
my $mergername = $ARGV[10]
or die "mergername error in .bat";
my $mergermax = $ARGV[11]
or die "mergermax error in .bat";
my $maxlev = $ARGV[12] 
or die "maxlev error in .bat";

# Global variables
my($all, $stat);
my(@stats);
my(@logins);
my(@users);
my(@steal);
my(@mergelevel);
my $steal;
my($parsed,$tmp,$mech);
my($a,$b,$c,$d);
my($c0,$c1,$c2,$c3,$c4,$c5,$c6);
my($str,$dex,$agil,$int,$conc,$contra);
my($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST);
my($clicks);
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
my $level = new Math::BigFloat;
my $loopmulti = new Math::BigFloat;
my $mergetime;
my $mergewait = "";
my $stealwait = "";
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
my $stealwaitfm = new Math::BigFloat;
my $mergewaitfm = new Math::BigFloat;
my $mergename = 0;
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
my$nos1=0;

if($debug == 1){print"\n Debug mode active.\n";}

if($chartype == 7){
	print "SINGLE STAT MODE, make sure you have selected the right stat.\n";
	$Alternate = 180;
	$shopyesno = 2;
}
if($chartype == 8){
	print "SINGLE STAT MODE, make sure you have selected the right stat.\n";
	$Alternate = 180;
	$shopyesno = 2;
}
if($chartype == 9){
	print "SINGLE STAT MODE, make sure you have selected the right stat.\n";
	$Alternate = 180;
	$shopyesno = 2;
}
if($chartype == 10){
	print "SINGLE STAT MODE, make sure you have selected the right stat.\n";
	$Alternate = 180;
	$shopyesno = 2;
}
if($chartype == 11){
	print "SINGLE STAT MODE, make sure you have selected the right stat.\n";
	$Alternate = 180;
	$shopyesno = 2;
}
if($chartype == 12){
	print "SINGLE STAT MODE, make sure you have selected the right stat.\n";
	$Alternate = 180;
	$shopyesno = 2;
}
if ($mergername eq "no merger"){
	$mergename = 1;
}
if($server == 1){
	$URLSERVER = "/m3/";
	$filefix = "m3";
}elsif($server == 2){
	$URLSERVER = "/Elysian-Fields/";
	$filefix = "EF";
}elsif($server == 3){
	$URLSERVER = "/attic/";
	$filefix = "attic";
}

($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
$Year = $Year + 1900;
$Month = $Month + 1;
my $MonthName;
if($Month == 1){
	$MonthName = "January";
}
if($Month == 2){
	$MonthName = "February";
}
if($Month == 3){
	$MonthName = "March";
}
if($Month == 4){
	$MonthName = "April";
}
if($Month == 5){
	$MonthName = "May";
}
if($Month == 6){
	$MonthName = "June";
}
if($Month == 7){
	$MonthName = "July";
}
if($Month == 8){
	$MonthName = "August";
}
if($Month == 9){
	$MonthName = "September";
}
if($Month == 10){
	$MonthName = "October";
}
if($Month == 11){
	$MonthName = "November";
}		
if($Month == 12){
	$MonthName = "December";
}


$temploop = $loopwait * 10;
#---------------------

sub Stealwait {
        $parsed = 0;
        while ($parsed == 0) {
			sleep($stime);
        $mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."merge.php");
        $a = $mech->content();
			if ($a =~ m/Parsed/) {
				$parsed = 1;
			}else{
				sleep(10);
				goto RETRY;
			}
		}
		if($debug == 1){
			open(FILE, ">>Stealwait.txt")
			or die "failed to open file!!!!";
			print FILE "Stealwait\n\n";
			print FILE "content\n\n";
			print FILE "$a\n\n";
			close(FILE);
			
			print "Stealwait\n";
		}

		if ($a =~ m/MERGE TO BECOME ONE!/){
			$stealwait = 0;
			$mergewait = 0;
			if($mergename == 1 or $mergername eq "no merger"){
				$stealtime = 1;
				$mergetime = 0;
			}else{
				$mergetime = 1;
				$stealtime = 0;
			}
			print"Ready to Steal or Merge.\n\n";
			
			
		}elsif ($a !~ m/MERGE TO BECOME ONE!/){
			$a = $mech->content();
			$a =~ m/(mode in.*seconds and)/s;
			$b = $1;
			$b =~ s/,//sg;
			$b =~ s/mode in //sg;
			$b =~ s/ seconds and//sg;
			$stealwait = $b;
			#print $b . "\n";
			$a =~ m/(merge in .* seconds.<hr>)/s;
			$b = $1;
			$b =~ s/,//sg;
			$b =~ s/merge in //sg;
			$b =~ s/ seconds.<hr>//sg;
			$mergewait = $b;
					$stealwaitfm = $stealwait;
					while($stealwaitfm =~ m/([0-9]{4})/){
					my $temp = reverse $stealwaitfm;
					$temp =~ s/(?<=(\d\d\d))(?=(\d))/,/;
					$stealwaitfm = reverse $temp;
				}
					$mergewaitfm = $mergewait;
					while($mergewaitfm =~ m/([0-9]{4})/){
					my $temp = reverse $mergewaitfm;
					$temp =~ s/(?<=(\d\d\d))(?=(\d))/,/;
					$mergewaitfm = reverse $temp;
				}
			print "Recovered enough to Steal in " . $stealwaitfm . " seconds.\n";
			print "Recovered enough to Merge in " . $mergewaitfm . " seconds.\n\n";
		}
	if($mergewait > $stealwait){
		$stealantal = $stealwait;
		$mergetime = 0;
		$stealtime = 1;
	}elsif($mergewait < $stealwait){
		$stealantal = $stealwait;
		if($mergename == 1 or $mergername eq "no merger"){
			$stealtime = 1;
			$mergetime = 0;
		}else{
			$mergetime = 1;
			$stealtime = 0;
		}
	}elsif($mergewait = $stealwait){
		$stealantal = $stealwait;
		if($mergename == 1 or $mergername eq "no merger"){
			$stealtime = 1;
			$mergetime = 0
		}else{
			$mergetime = 1;
			$stealtime = 0;
		}
	}
	if($stealantal == 0){$stealantal = 1800;}
	return();
}


sub Mergetest{
	$parsed = 0; 
	while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."merge.php");
		$a = $mech->content();
		if ($a =~ m/Parsed/){
			$parsed = 1;
		}else{
			sleep(10);
			goto RETRY;
		}
	}
	if($debug == 1){
		open(FILE, ">>Mergetest.txt")
		or die "failed to open file!!!!";
		print FILE "Mergetest\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		print "Mergetest\n";
	}
	$a =~ s/\s//sg;
	$a =~ s/inactive/  BLOCKER /sgi; 
	$a =~ s/EMERGETOBETHEONE!/  STOPPER /sg; 
	$a =~ s/(.*)( BLOCKER )//sg; #remove before
	$a =~ s/  STOPPER .*//sg; #remove after
	$a =~ s/"//sg;
	$a =~ s/<//sg;
	$a =~ s/>//sg;
	$a =~ s/optionvalue=//sg;
	$a =~ s~/option~~sg;
	#$a =~ s/\d//sg;
	$a =~ s~/select/tdtdinputtype=submitname=actionvalue=~~sg;
	$MergeList = $a;
	if ($MergeList =~ m/$mergername/i){
		print "MERGER WITH NAME '$mergername' AVAILABLE!!!\n\n";
		$Mergeready = 1;
		&MergeId;
		
	}else{
		print "No merger with name '$mergername' available.\n\n";
		$Mergeready = 0;
		$mergetime = 0;
		$stealtime = 1;
		goto RETRY;
	}
}

sub MergeId{
	$parsed = 0; 
	while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."merge.php");
		$a = $mech->content();
		if ($a =~ m/Parsed/){
			$parsed = 1;
		}else{
			sleep(10);
			goto RETRY;
		}
	}
	if($debug == 1){
		open(FILE, ">>MergeId.txt")
		or die "failed to open file!!!!";
		print FILE "MergeId\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		print "MergeId\n";
	}
	$a =~ s/inactive+/  BLOCKER /sgi; 
	$a =~ s/MERGE TO BECOME ONE!/  STOPPER /sg; 
	$a =~ s/(.*)( BLOCKER )//sg; #remove before
	$a =~ s/  STOPPER .*//sg; #remove after
	if($debug == 1){
		open(FILE, ">>MergeId2.txt")
		or die "failed to open file!!!!";
		print FILE "MergeId2\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		print "MergeId\n";
	}
	$a =~ s/lady//sgi;
	$a =~ s/dame//sgi;
	$a =~ s/masteries//sgi;
	$a =~ s/judgette//sgi;
	$a =~ s/cannoness//sgi;
	$a =~ s/counsel//sgi;
	$a =~ s/baroness//sgi;
	$a =~ s/mayoress//sgi;
	$a =~ s/viscountess//sgi;
	$a =~ s/earless//sgi;
	$a =~ s/countess//sgi;
	$a =~ s/marchioness//sgi;
	$a =~ s/generalia//sgi;
	$a =~ s/duchess//sgi;
	$a =~ s/princess//sgi;
	$a =~ s/queen//sgi;
	$a =~ s/lord//sgi;
	$a =~ s/sir//sgi;
	$a =~ s/master//sgi;
	$a =~ s/judge//sgi;
	$a =~ s/cannoner//sgi;
	$a =~ s/council//sgi;
	$a =~ s/baron//sgi;	
	$a =~ s/major//sgi;
	$a =~ s/viscount//sgi;
	$a =~ s/earl//sgi;
	$a =~ s/count//sgi;	
	$a =~ s/marquess//sgi;
	$a =~ s/general//sgi;
	$a =~ s/duke//sgi;
	$a =~ s/prince//sgi;
	if ($a !~ m/viking/i){
        $a =~ s/king//sgi;
    }
	$a =~ s/admin//sgi;
	$a =~ s/cop//sgi;
	$a =~ s/mod//sgi;
	$a =~ s/support//sgi;
	$a =~ s/demon//sgi;
	$a =~ s/danger//sgi;
	$a =~ s/untrust//sgi;
	$a =~ s/beggar//sgi;
	$a =~ s/criminal//sgi;
	$a =~ s/stealer//sgi;
	$a =~ s/helper//sgi;
	$a =~ s/sir//sgi;
	$a =~ s/heir//sgi;
	$a =~ s/Merger//sgi;
	$a =~ s/<option value="/~/sgi;
	$a =~ s/\s//sgi;
	$b = $a;
	if($debug == 1){
		open(FILE, ">>MergeId3.txt")
		or die "failed to open file!!!!";
		print FILE "MergeId3\n\n";
		print FILE "content\n\n";
		print FILE "$b\n\n";
		close(FILE);
		
		print "MergeId\n";
	}
	$b =~ s/,//sgi;
	my $countit = 0;
	my $grab = "not empty";
		until ($grab eq ""){
			@mergelevel = split(/<\/option/, $b);
			$grab = $mergelevel[$countit];
			$countit++;
		}
	if($debug == 1){

	}
	my $mergelevel;
	foreach $mergelevel (@mergelevel){
		$mergelevel =~ m/(\[Level:.*\])/s;
		my $mlevel = $1;
		$mlevel =~ s/\[Level://sgi;
		$mlevel =~ s/\]//sgi;
		if($mlevel >= $mergermax){$mergelevel = "";}
		if($mergelevel ne ""){
			if($mergelevel =~ m/.*$mergername.*/i){
				$a = $mergelevel;
				last;
			}
		}
	}
	$a =~ s/$mergername.*/@/sgi;;
	$a =~ s/"//sgi;
	$a =~ s/>//sgi;
	$a =~ s/(.*)(~)//sg; #remove before
	$a =~ s/@.*//sg; #remove after
	$a =~ s/\s*$//;
	$MergeId = "\"".$a."\"";
	&MergeName;
}

sub MergeName{
	$parsed = 0; 
	while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."merge.php");
		$a = $mech->content();
		if ($a =~ m/Parsed/){
		$parsed = 1;
		}else{
			sleep(10);
			goto RETRY;
		}
	}
	if($debug == 1){
		open(FILE, ">>MergeName.txt")
		or die "failed to open file!!!!";
		print FILE "MergeName\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		print "MergeName\n";
	}
	    $a = $mech->content();
		
		$a =~ s/<\/select>.*//sg; #remove after
		$a =~ s/(.*)($MergeId>)//sg; #remove before
		$a =~ s/<\/option>.*//sg; #remove after
		$a =~ s/"//sgi;
		$a =~ s/>//sgi;
		$a =~ s/\s*$//;
		$MergeName = $a;
	return();
}

sub Merge {
		$parsed = 0; 
		while ($parsed == 0){
		sleep($stime);
		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."merge.php");
		$a = $mech->content();
		if ($a =~ m/Parsed/){
		$parsed = 1;
		}else{
			sleep(10);
			goto RETRY;
		}
	}
	if($debug == 1){
		open(FILE, ">>Merge.txt")
		or die "failed to open file!!!!";
		print FILE "Merge\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		print "Merge\n";
	}
	$a = $mech->content();
	print "Merging with: " . $MergeName . "\n\n";
	$mech->form_number(0);
	$mech->select("inactive", $MergeName);
	sleep($stime);
	$mech->click_button('value' => 'MERGE TO BECOME ONE!');
	$a = $mech->content();
	print "Successfully merged with: " . $MergeName . "\n\n";
		$a =~ m/(Yours.*Merging takes 60)/s;
        $a = $1;
		$a =~ s/Yours//sgi;
		$a =~ s/Merging takes 60//sgi;
		$a =~ s/<\/td><td>//si;
		$a =~ s/<\/td><\/tr>//si;
		#Weapon
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/			/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Attackspell
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Healspell
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Helmet
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/			/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Shield
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/			/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Amulet
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/			/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Ring
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/			/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Armor
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/			/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Belt
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/			/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Pants
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/			/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Hands
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/			/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Feet
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/			/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Strength
		$a =~ s/<tr><th colspan=3><br><\/th><\/tr><tr><td>//si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Dexterity		
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Agility		
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/			/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#intelligence
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Concentration
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Contravention
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Exp
		$a =~ s/<tr><th colspan=3><br><\/th><\/tr><tr><td>/\n/si;
		$a =~ s/<\/td><td>/	/si;
		$a =~ s/<\/td><td>/		/si;
		$a =~ s/<\/td><\/tr>//si;
		#Gold
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/	/si;
		$a =~ s/<\/td><td>/	/si;
		$a =~ s/<\/td><\/tr>//si;
		#Stash
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/	/si;
		$a =~ s/<\/td><td>/				/si;
		$a =~ s/<\/td><\/tr>//si;
		#Life
		$a =~ s/<tr><td>//si;
		$a =~ s/<\/td><td>/	/si;
		$a =~ s/<\/td><td>/			/si;
		$a =~ s/<\/td><\/tr>//si;
		$a =~ s/<tr><th colspan=3><b>//si;
		$a =~ s/<\/b><\/th><\/tr><tr><td colspan=3><br>/\n/si;
		$a =~ s/<br>/\n/si;
		$a =~ s/<br>/\n/si;
		$a =~ s/<br>/\n/si;
		$a =~ s/<br><\/td><\/tr><\/table><hr>//si;
		#$a =~ s/<\/select>.*//sg; #remove after
		#$a =~ s/(.*)($MergeId)//sg; #remove before
		#$a =~ s/<\/option>.*//sg; #remove after
		open(FILE, ">>$name $filefix MERGERESULTS.txt")
		or die "failed to open file!!!!";
		print FILE "$a\n";
		close(FILE);
}

sub Steal {
$parsed = 0;
	while($parsed == 0){
	sleep($stime);
	$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."steal.php");
    $a = $mech->content();
	if ($a =~ m/Parsed/){
	$parsed = 1;
	}else{
			sleep(10);
			goto RETRY;
		}
	}
	if($debug == 1){
		open(FILE, ">>Steal.txt")
		or die "failed to open file!!!!";
		print FILE "Steal\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		print "Steal\n";
	}
		$a = $mech->content();		
        if ($a =~ m/Freeplay/) { # steal only if we have freeplay
		$a =~ s/<\/select>.*//sg; #remove after
		$a =~ s/(.*)(<select )//sg; #remove before
		$a =~ s/name=Opp>//si;
		my $i = 0;
		$tmp = "";
		if($stealchar =~ m/(no steal)/i){}else{
			if($a =~ m/\b$stealchar\b/i){
				until ($tmp =~ m/($stealchar )/i){
					@steal = split(/<\/option>/, $a);
					$tmp = "$steal[$i]"."</option>";
					$i++;
				}
			}
		}
            if($tmp =~ m/($stealchar )/i) {} else {$stealtime = 0;print "Stealer not found! - not stealing!\n"; goto RETRY;}
				my $stealfrom = $tmp;
				$stealfrom =~ s/<option>//sg;
				$stealfrom =~ s/<\/option>//sg;
                print "Stealing from: " . $stealfrom;
                $mech->form_number(0);
                $mech->select("Opp", $tmp);
				sleep($stime);
                $mech->click_button('value' => 'Steal Stats or Items');
                $a = $mech->content();
                $a =~ m/(sleepers.*This)/s;
                $b = $1;
                $b =~ s/<.*?>//sg;
                $b =~ s/sleepers//sg;
                $b =~ s/This//sg;
                print $b;
			($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
			$Year = $Year + 1900;
			$Month = $Month + 1;
			my $MonthName;
			if($Month == 1){$MonthName = "January";}
			if($Month == 2){$MonthName = "February";}
			if($Month == 3){$MonthName = "March";}
			if($Month == 4){$MonthName = "April";}
			if($Month == 5){$MonthName = "May";}
			if($Month == 6){$MonthName = "June";}
			if($Month == 7){$MonthName = "July";}
			if($Month == 8){$MonthName = "August";}
			if($Month == 9){$MonthName = "September";}
			if($Month == 10){$MonthName = "October";}
			if($Month == 11){$MonthName = "November";}		
			if($Month == 12){$MonthName = "December";}
				my $stealrec = $b;
				open(FILE, ">>$title$name $filefix ~ $MonthName $Year StealRecord.txt")
				or die "failed to open file!!!!";
				print FILE "[$Day/$Month/$Year] ~ [$Hour:$Minute:$Second] - you stole $stealrec\n";
				close(FILE);
        }else{$stealtime = 1; $stealwait = $stealwait + 1500; print "Freeplay not detected, stealing cancelled...\n";goto GOTO;}
	return();
}

sub Lowlevel {
	$parsed = 0; 
	while ($parsed == 0){
		sleep($stime);
#		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
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
	#test for free upgrade
	if ($all =~ m/Click here to upgrade/) {
		sleep($stime); $mech->form_number(0);$mech->click();
		print "Free upgrade detected and cleared. Restarting\n";
		goto RETRY;
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
	if($server == 1 or $server == 3){
		$wdlevel->bdiv('603'); 
		$aslevel->bdiv('554'); 
		$mslevel->bdiv('84'); 
		$deflevel->bdiv('42'); 
		$arlevel->bdiv('57'); 
		$mrlevel->bdiv('72');
	}elsif($server == 2){
		$wdlevel->bdiv('579'); 
		$aslevel->bdiv('577'); 
		$mslevel->bdiv('51'); 
		$deflevel->bdiv('50'); 
		$arlevel->bdiv('72'); 
		$mrlevel->bdiv('73'); 
	}
	$wdlevel->bfround(1);
	$aslevel->bfround(1);
	$mslevel->bfround(1);
	$deflevel->bfround(1);
	$arlevel->bfround(1);
	$mrlevel->bfround(1);

	$aslevel->bmul('2.5'); # multiplier for correct AS
	$wdlevel->bmul('2.5'); #multiplier for correct wd
	
	if($server == 1 or $server == 3){
		if($chartype ==4){
			$wdlevel->bdiv('2.5');
		}
		if($chartype ==5){
			$aslevel->bdiv('2.5');
		}
	}
	if($server == 2){
		if($chartype ==4){
			$wdlevel->bdiv('2.5');
		}
		if($chartype ==5){
			$aslevel->bdiv('2.5');
		}
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
	return();
}

sub LowFight {
# setup fight
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
		open(FILE, ">>LowFight.txt")
		or die "failed to open file!!!!";
		print FILE "LowFight\n\n";
		print FILE "content\n\n";
		print FILE "$a\n\n";
		close(FILE);
		
		print "LowFight\n";
	}
	$mech->form_number(2);
	$mech->field("Difficulty", $level);
	$mech->click();
	$mech->form_number(1);
	$mech->click();
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
	if($a =~ m/(fought.)/){
		$of = $a;
		$of =~ m/(fought .* of .*<\/p>)/;
		$of = $1;
		$of =~ s/(.*)(f )//si;
		$of =~ s/<\/p>//s;
		if($of =~ m/(Average )/){
			$of =~ s/<br>.*//s;
			$of =~ s/<br>//s;
		}
		$ofcounter = $of;
	}
	if($a =~ m/(fought.)/){
		$fought = $a;
		$fought =~ m/(fought .* of)/;
		$fought = $1;
		#$fought =~ s/(.*)(of)//si;
		$fought =~ s/fought //s;
		$fought =~ s/ of//s;
		$foughtcounter = $fought;
		$capture = $a;
		if($foughtcounter == $ofcounter){
			if($capture =~ m/(Currently fought)/){
				if ($of == 600){
					$capture =~ s/(.*)(600<br>)//si;
				}else{
					$capture =~ s/(.*)(10<br>)//si;
				}
				$capture =~ s/<\/span><\/p>Next.*//s; #remove after
				$capture =~ s/<b>//gs;
				$capture =~ s/<\/b>//gs;
				$capture =~ s/<span style="color: #06c200">//gs;
				$capture =~ s/<span style="color: #efdd00">//gs;
				$capture =~ s/<\/span>//gs;
				$capture =~ s/<br>/\n/gs;
			}
		}
	}
	
	$a =~ m/(You win.*exp )/;
	$a =~ m/(battle)/;
	$a =~ m/(You have been jailed for violating our rules)/;
	#print $1 . "\n";
	#my $antal = 500 + int rand (500);
	$stealantal = new Math::BigFloat $stealantal;
	my$divided = new Math::BigFloat $loopwait;
	if ($loopwait <= 0.3){$divided = 0.4;}
	if ($loopwait >= 1.0){$divided = 0.9;}
	$divided = $divided*100;
	$divided = $divided/90;
	$stealantal->bdiv($divided);
	$stealantal->bstr();
	$stealantal->bfround(1);
	$antal = $stealantal;
	if($antal >= 3000){
	   $antal = 800;
	}
# REPEAT:

	while($antal > 0) {
		sleep($loopwait); #default = 0.3
		$antal = $antal -1;
		my $retries = 0;
		retry:
		$mech->reload();
		$nos1 = 0;
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
			if($a =~ m/(fought.)/){
		if($foughtcounter == $ofcounter){
				open(FILE, ">>$name $filefix true averages $MonthName $Year.txt")
				or die "failed to open file!!!!";
				print FILE "True average's for $name at $Hour:$Minute:$Second~$Day/$Month/$Year\n\n";
				print FILE "$capture\n\n";
				close(FILE);
		}
	}
# KILLED
		if($a =~ m/(been.*slain)/) {
			print "ERROR - TOO HIGH MONSTER LEVEL! - you were slain!\n";exit(0);
		}
# JAILED
		if ($b =~ m/jail time.*<br>/) {
			$nos1=1;
		}

# LOGGED OUT

		if ($c =~ m/logged/) {
			print "LOGGED OUT! sleeping for 5 seconds before restart!\n";
			sleep(5);
			goto START;
		}


# STEAL TIME? then exit to steal
		if ($antal <= 0) {
			sleep(3);
			print "Waiting last few seconds before steal\n";
			goto START;
		}
		
		if ($b =~ m/(400 Bad Request)/) {$b=0;
		    print"400 error restarting.";
			goto START;
		}

		$a = $b;
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		$a =~ m/(You win.*exp )/;
		$a =~ m/(The battle tied.)/;
		if($nos1 != 1){
			print "$antal: [$Hour:$Minute:$Second]: " . $1 . "\n";
		}else{
			print "$antal: [$Hour:$Minute:$Second]: Jailed. Waiting 5 seconds before continuing\n"; 
			sleep(5);
		}
		

		$levelnow = $levelnow+1;
# level up if necessary
		if (($b =~ m/(Level.*HERE!)/) and ($indefcont != 1)) {$b=0;
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
		if($server == 1 or $server == 3){
			if ($chartype == 1) {
				$perstat = $a/7;
				$perstat = int($perstat);
				$str = 0;
				$dex = 0;
				$agil = $perstat;
				$int = $perstat*2;
				$conc = $perstat*4;
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
				$perstat = $a/3;
				$perstat = int($perstat);
				$str = $perstat*2;
				$dex = $perstat;
				$agil = 0;
				$int = 0;
				$conc = 0;
				$contra = 0;
			}		
			if ($chartype == 5) {
				$perstat = $a/3;
				$perstat = int($perstat);
				$str = 0;
				$dex = 0;
				$agil = 0;
				$int = $perstat*2;
				$conc = $perstat;
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
		}elsif($server == 2){
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
			&TestShop;
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
#		$mech->get("https://www.kingsofkingdoms.com/".$URLSERVER."fight_control.php");
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

	$wdlevel = new Math::BigFloat $stats[1];
	$aslevel = new Math::BigFloat $stats[2];
	$mslevel = new Math::BigFloat $stats[4];
	$deflevel = new Math::BigFloat $stats[5];
	$arlevel = new Math::BigFloat $stats[6];
	$mrlevel = new Math::BigFloat $stats[7];

	#cpms m2 only
	if($server == 1 or $server == 3){
		$wdlevel->bdiv('1661622');
		$aslevel->bdiv('1877897');
		$mslevel->bdiv('3028631');
		$deflevel->bdiv('1817170');
		$arlevel->bdiv('363482.2');
		$mrlevel->bdiv('363497.2');
	}elsif($server == 2){
		$wdlevel->bdiv('3686988');
		$aslevel->bdiv('3654459');
		$mslevel->bdiv('1855884');
		$deflevel->bdiv('1839530');
		$arlevel->bdiv('367532');
		$mrlevel->bdiv('374184');
	}
	$wdlevel->bfround(1);
	$aslevel->bfround(1);
	$mslevel->bfround(1);
	$deflevel->bfround(1);
	$arlevel->bfround(1);
	$mrlevel->bfround(1);

	$aslevel->bmul('2.5'); # multiplier for correct AS
	$wdlevel->bmul('2.5'); #multiplier for correct wd
	if($server == 1){
		if($chartype ==4){
			$wdlevel->bdiv('4.7');
		}
		if($chartype ==5){
			$aslevel->bdiv('4.7');
		}
	}
	if($server == 2){
		if($chartype ==4){
			$wdlevel->bdiv('2.5');
		}
		if($chartype ==5){
			$aslevel->bdiv('2.5');
		}
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

	printf " --> CPM level: %.3e\n", $level->bstr();
}

sub Fight {
# setup fight
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
	$cpm =~ m/(\<option id=208\>208.*Duke)/;
    $cpm = $1;
    $cpm =~ s/ - Shadowlord Duke//g;
    $cpm =~ s/\>209/\>/;
    $cpm =~ s/<.*?>//g;
	print $cpm . "\n";
	$mech->form_number(1);
	$mech->select("Monster", $cpm);
	$mech->click();
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
	if($a =~ m/(fought.)/){
		$of = $a;
		$of =~ m/(fought .* of .*<\/p>)/;
		$of = $1;
		$of =~ s/(.*)(f )//si;
		$of =~ s/<\/p>//s;
		if($of =~ m/(Average )/){
			$of =~ s/<br>.*//s;
			$of =~ s/<br>//s;
		}
		$ofcounter = $of;
	}
	$a =~ m/(You win.*exp )/;
	$a =~ m/(battle)/;
	$a =~ m/(You have been jailed for violating our rules)/;
	#print $1 . "\n";
	#my $antal = 500 + int rand (500);
	$stealantal = new Math::BigFloat $stealantal;
	my$divided = new Math::BigFloat $loopwait;
	if ($loopwait <= 0.3){$divided = 0.4;}
	if ($loopwait >= 1.0){$divided = 0.9;}
	$divided = $divided*100;
	$divided = $divided/90;
	$stealantal->bdiv($divided);
	$stealantal->bstr();
	$stealantal->bfround(1);
	$antal = $stealantal;
	if($antal >= 3000){
		$antal = 800;
	}
	my $averagecountdown = 600+1;
# REPEAT:
	while($antal > 0) {
		sleep($loopwait); #default = 0.3
		$antal = $antal -1;
		my $retries = 0;
		retry:
		$mech->reload();
		$nos1 = 0;
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
		if($a =~ m/(fought.)/){
			$fought = $a;
			$fought =~ m/(fought .* of)/;
			$fought = $1;
			#$fought =~ s/(.*)(of)//si;
			$fought =~ s/fought //s;
			$fought =~ s/ of//s;
			$foughtcounter = $fought;
			$capture = $a;
			if($foughtcounter == $ofcounter){
				if($capture =~ m/(Currently fought)/){
					if ($of == 600){
						$capture =~ s/(.*)(600<br>)//si;
					}else{
						$capture =~ s/(.*)(10<br>)//si;
					}
					$capture =~ s/<\/span><\/p>Next.*//s; #remove after
					$capture =~ s/<b>//gs;
					$capture =~ s/<\/b>//gs;
					$capture =~ s/<span style="color: #06c200">//gs;
					$capture =~ s/<span style="color: #efdd00">//gs;
					$capture =~ s/<\/span>//gs;
					$capture =~ s/<br>/\n/gs;
				}
			}
		}elsif($a =~ m/(Battle Tied.)/){}
	if($a =~ m/(fought.)/){
		if($foughtcounter == $ofcounter){
				open(FILE, ">>$name $filefix true averages $MonthName $Year.txt")
				or die "failed to open file!!!!";
				print FILE "True average's for $name at $Hour:$Minute:$Second~$Day/$Month/$Year\n\n";
				print FILE "$capture\n\n";
				close(FILE);
		}
	}
	
# KILLED
		if($a =~ m/(been.*slain)/) {
			print "ERROR - TOO HIGH MONSTER LEVEL! - you were slain!\n";
			exit(0);
		}
# JAILED
		if ($b =~ m/jail time.*<br>/) {
			$nos1=1;
		}

# LOGGED OUT

		if ($c =~ m/logged/) {
			print "LOGGED OUT! sleeping for 5 seconds before restart!\n";
			sleep(5);
			goto START;
		}


# STEAL TIME? then exit to steal
		if ($antal <= 0) {
			sleep(3);
			print "Waiting last few seconds before steal\n";
			goto START;
		}
		if (($b =~ m/(400 Bad Request)/)) {$b=0;
		    print"400 error restarting.";
			goto START;
		}
		$a = $b;
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		$Year = $Year + 1900;
		$a =~ m/(You win.*exp )/;
		$a =~ m/(The battle tied.)/;
		if($nos1 != 1){
			print "$antal: [$Hour:$Minute:$Second]: " . $1 . "\n";
		}else{
			print "$antal: [$Hour:$Minute:$Second]: Jailed. Waiting 5 seconds before continuing\n"; 
			sleep(5);
		}

		$levelnow = $levelnow+1;


			# level up if necessary
		if (($b =~ m/(Level.*HERE!)/) and ($indefcont != 1)) {$b=0;
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
			sleep($stime);
			if($chartype ==1){
				if(($aslevel <= $deflevel) && ($aslevel <= $mrlevel)) {
					$mech->form_number(1);
					$mech->field("Intelligence", $numlevs);
					$mech->click_button('value' => 'Level Up!!!');
					print "You Leveled "."$numlevs1"." Intelligence\n";
					&TestShop;
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
					&TestShop;
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
					&TestShop;
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
				&TestShop;
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
					&TestShop;
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
					&TestShop;
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
	return();
}

sub TestShop{
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
				open(FILE, ">>TestShop.txt")
				or die "failed to open file!!!!";
				print FILE "Testshop\n\n";
				print FILE "content\n\n";
				print FILE "$a\n\n";
				close(FILE);
				
				print "Testshop\n";
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
	}else{
		print "Shops were not bought this time\n";
	}
}
	
sub BuyUpgrades{
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
				open(FILE, ">>BuyUpgrades.txt")
				or die "failed to open file!!!!";
				print FILE "BuyUpgrades\n\n";
				print FILE "content\n\n";
				print FILE "$a\n\n";
				close(FILE);
				
				print "BuyUpgrades\n";
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
			sleep($stime);
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
			sleep($stime);
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
			sleep($stime);
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
			sleep($stime);
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
			sleep($stime);
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
		if($shop9 == 0){
			$mech->field("Belt", $maxshop);
		}
		if($shop11 == 0){
			$mech->field("Hand", $maxshop);
		}
		if($shop12 == 0){
			$mech->field("Feet", $maxshop);
		}
			sleep($stime);
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
	goto START;
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
	
	$c =~ s/(.*)(Actual)//si; #remove before
	$c =~ s/(.*)(Min)//si; #remove before
	$c =~ s/Congratulations.*//si; #remove after
	$c =~ s/\.//gi;
	$c =~ s/<br>/a/i;
	$c =~ s/<br>/b/i;
	$c =~ s/<br>/c/i;
	$c =~ s/<br>/d/i;
	$c =~ s/<br>/e/i;
	$c =~ s/<br>/f/i;
	$c =~ s/<br>/g/i;
	$c =~ s/td/h/i;
	$c =~ s/<//i;
	$c =~ s/>//i;
	$c =~ s/\///i;
		$c =~ m/(a.*b)/;
			$c0 = $1;
				$c0 =~ s/[a-z]//ig;
				$c0= new Math::BigFloat $c0;
		$c =~ m/(b.*c)/;
			$c1 = $1;
				$c1 =~ s/[a-z]//ig;
				$c1= new Math::BigFloat $c1;
		$c =~ m/(c.*d)/;
			$c2 = $1;
				$c2 =~ s/[a-z]//ig;
				$c2= new Math::BigFloat $c2;
		$c =~ m/(d.*e)/;
			$c3 = $1;
				$c3 =~ s/[a-z]//ig;
				$c3= new Math::BigFloat $c3;
		$c =~ m/(e.*f)/;
			$c4 = $1;
				$c4 =~ s/[a-z]//ig;
				$c4= new Math::BigFloat $c4;
		$c =~ m/(f.*g)/;
			$c5 = $1;
				$c5 =~ s/[a-z]//ig;
				$c5= new Math::BigFloat $c5;
		$c =~ m/(g.*h)/;
			$c6 = $1;
				$c6 =~ s/[a-z]//ig;
				$c6= new Math::BigFloat $c6;

   
		if(($c0 >= "731420819") or ($c1 >= "734691740")){
			if($chartype == 1 or 6){
				if(($c3 >= "371176860")or($c4 >= "367905939")){
					if(($c5 >= "73506388")or($c6 >= "74836787")){
						$cpmready = 1;
					}else{
						$cpmready = 0;
					}
				}else{
					$cpmready = 0;
				}
			}elsif(($c5 >= "72696432")or($c6 >= "72699424")){
				$cpmready = 1;
			}else{
				$cpmready = 0;
			}
		}else{
			$cpmready = 0;
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
}elsif($server == 3){
	open(LOGINS, "atticlogins.txt")
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
	if($cpmready == 0){
		print "\nLow Level Fight mode\n\n";
	}else{
		print "\nHigh Level Fight mode\n\n";
	}
	if($stealchar =~ m/(no steal)/i){print"steal set to \"no steal\"\n\n";}else{}
	&Stealwait;
	RETRY:
	if ($stealwait == 0) {
		if ($stealwait == 0 and $mergetime == 1) {
			&Mergetest;
			if ($Mergeready == 1){
				&Merge;
				goto RETRY;
			}
		}elsif($stealwait == 0 and $stealtime == 1){
			if($stealchar =~ m/(no steal)/i){}else{&Steal;}
		}	
	}
	GOTO:
	if($cpmready == 0){
		&Lowlevel;
		&LowFight;	
	}else{
		&CPMlevel;
		&Fight;
	}

}

goto RETRY;