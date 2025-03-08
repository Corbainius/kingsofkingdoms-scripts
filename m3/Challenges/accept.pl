# turn on perl's safety features and load modules
use strict;
use warnings;
use integer;
use Math::BigFloat;
use Math::BigInt;
use Time::HiRes qw(sleep);
use WWW::Mechanize;
use POSIX qw(strftime);

my $server = $ARGV[0]
or die "Server failed";
my $username = $ARGV[1]
or die "username error";
my $password = $ARGV[2]
or die "password error";
my $char = $ARGV[3]
or die "accept from error";

# Global variables
my($all, $stat);
my(@stats);
my(@challenges);
my($parsed,$tmp,$mech);
my($a,$b,$c,$d,$g,$h,$i);
my($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST);
my($clicks);
my $exper;
my $exper1 = new Math::BigInt;
my $noaction = 0;
my $proxyipport;
my $challlist;
my $temp1 = "a";
my $temp2 = "a";
my $arraysize;
my $URLSERVER;
my $filefix;
#---------------------

if($server == 1){
	$URLSERVER = "/m3/";
	$filefix = "m3";
}elsif($server == 2){
	$URLSERVER = "/Elysian-Fields/";
	$filefix = "EF";
}

sub Acceptchall{
	$parsed = 0;
	while ($parsed == 0){
		sleep(1);
		$mech->get("http://www.kingsofkingdoms.com".$URLSERVER."schedule.php");
		$g = $mech->success();
		$h = $mech->response();
		$i = $mech->status();
		$a = $mech->content();
		$b = $mech->content();
		$c = $mech->content();
		if($i == 200){
			if($a =~ m/Parsed/){
				$parsed = 1;
			}else{
				sleep(10);
				exit();
			}
		}elsif(($i == 500) || ($i == 523)){
			print "Trouble Connecting to internet....Probably\n";
			sleep(30);
			exit();
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
		return();
	}
	if($b =~ m/($char*.*Accept)/si){
		$b = $1;
		$b =~ m/(href=".*Accept)/s;
		$b = $1;
		$b =~ s/\">//g;
		$b =~ s/Accept//;
		$b =~ s/href="//;
		$noaction = 1;
		sleep (0.5);
		$mech->get("http://www.kingsofkingdoms.com".$URLSERVER."schedule.php" . $b);
		$a = $mech->content();
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		if ($a =~ m/(You have.*slain.*xp )/s){
			$temp1 = $1;
			$temp1 =~ s/(<br>.*<br>)//s;
			print "[$Hour:$Minute:$Second]: " . $temp1 . "\n";
		}	
	}
	if($noaction == 0){
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
		print"[$Hour:$Minute:$Second]: No valid challenges\n";
		return();
	}
}

#---------------------
# MAIN
#---------------------

$mech = WWW::Mechanize->new();
$mech->agent_alias( 'Windows Mozilla' );

print " 
         \\\\\\///
        / _  _ \\\
      (| (.)(.) |)
.---.OOOo--()--oOOO.---.
|                      |
| www.lordsoflords.uk |
|                      |
'---.oooO--------------'
     (   )   Oooo.
      \\\ (    (   )
       \\\_)    ) /
             (_/
\n";

#Login

$parsed = 0; 
while ($parsed == 0){
sleep(1);
$mech->get("http://www.kingsofkingdoms.com".$URLSERVER."login.php");
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
	$mech->click();
	($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
	print "[$Hour:$Minute:$Second] - logged in Successfully\n";
}else{
	sleep(5);
	exit();
}

my $timer = 1;

while($timer == 1){
	&Acceptchall;
}

	exit();
