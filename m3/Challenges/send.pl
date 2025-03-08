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
print "Server = $server\n";
my $username = $ARGV[1]
or die "username error";
print "User = $username\n";
my $password = $ARGV[2]
or die "password error";
print "Pass = $password\n";
my $firsttime = $ARGV[3]
or die "firsttime error";
print "First time = $firsttime\n";
my $char1 = $ARGV[4]
or die "send to error";
print "Send = $char1\n";


# Global variables
my($all, $stat);
my(@stats);
my(@challenges);
my($parsed,$tmp,$mech);
my($a,$b,$c);
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

sub ChallList{
	$parsed = 0;
	while ($parsed == 0){
		sleep(1);
		$mech->get("http://www.kingsofkingdoms.com".$URLSERVER."challenge.php");
		$a = $mech->content();
		$b = $mech->content();
		if ($a =~ m/Players that you can challenge/){
			$parsed = 1;
		}else{
			sleep(10);
			exit();
		}
	}	
	($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
	$b =~ m/(<select name.*<\/select>)/s;
	$b = $1;
	$c = $b;
	until ($c !~ m/option/i){
		$c =~ m/(<option?.+?option>?)/i;
		$temp1 = $1;
		$c =~ s/(<option?.+?option>?)//i;
		if($temp1 =~ m/$char1/i){
			push (@challenges, $temp1); 
			$temp1 = "a";
		} 
	}
	$arraysize = @challenges;
	
	($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
	if($arraysize > 0){
		while($arraysize > 0){
			my $first = shift @challenges;
			$first =~ m/(>.+<)/s;
			$first = $1;
			$first =~ s/>//g;
			$first =~ s/<//g;
			sleep(1);
			$mech->form_number(0);
			$mech->select("Players", $first);
			$mech->click_button('value' => 'Challenge');
			$a = $mech->content();
			$b = $mech->content();
			if($b =~ m/challenged/i){
				$b =~ m/(you have challenged.+<\/b>)/i;
				$b = $1;
				$b =~ s/<br>//i;
				$b =~ s/<b>//i;
				$b =~ s/<br>//i;
				$b =~ s/<\/b>//i;
				print "[$Hour:$Minute:$Second] - $b\n";
			}else{
				print "[$Hour:$Minute:$Second] - You challenged $first.\n";
			}
			$arraysize = @challenges;
		}
	}else{
		print "[$Hour:$Minute:$Second] - No Challenges to send.\n";
	}
}

#---------------------
# MAIN
#---------------------

# create a new proxy browser
$mech = WWW::Mechanize->new();
$mech->agent_alias( 'Windows Mozilla' );

if($firsttime == 1){
	$mech->add_handler("request_send",  sub { shift->dump; return });
	$mech->add_handler("response_done", sub { shift->dump; return });
}
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
	if($a =~ m/Enter Lol!/){
		$parsed = 1;
	}else{
		sleep(10);
		exit();
	}
}
if($a =~ m/Username/){
	$mech->form_number(0);
	$mech->field("Username", $username);
	$mech->field("Password", $password);
	$mech->click();
	$a = $mech->content();
	($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
	if($a =~ m/Login failed/){
		print "[$Hour:$Minute:$Second] - Login Failed\n";
		exit();
	}else{
		print "[$Hour:$Minute:$Second] - Login Successful\n";
	}
}else{
	sleep(5);
	exit();
}

my $timer = 1;

while($timer == 1){

	&ChallList;
}

exit();
