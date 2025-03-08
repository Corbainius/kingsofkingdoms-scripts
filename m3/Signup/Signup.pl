use strict;
use warnings;
use integer;
use Time::HiRes qw(sleep);
use WWW::Mechanize;

my $server = $ARGV[0]
or die "Server failed";
my $username = $ARGV[1]
or die "Partial error";
my $password = $ARGV[2]
or die "Password error";
my $charname = $ARGV[3]
or die "Charname error";
my $mergernumber = $ARGV[4]
or die "Mergernumber error";
my $race = $ARGV[5]
or die "Custom race error";
my $friend = $ARGV[6]
or die "Friend error";

# Global variables
my($all, $stat);
my(@stats);
my($parsed,$tmp,$mech);
my($a,$b,$c,$aa,$ab,$ac,$ad);
my($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST);
my($clicks);
my $mytime;
my $URLSERVER;
my $answer = 0;
my $userinc = 1;
my $charinc = "aaaa";
my $user;
my $char;
my $sex = "<option>Lord</option>";
my $filefix;
my $friendurl = "";

if($server == 1){
	$URLSERVER = "/m3/";
	$filefix = "m3";
}elsif($server = 2){
	$URLSERVER = "/sotse/";
	$filefix = "sotse";
}

if($friend ne "nofriend"){
	$friendurl = "?friend=".$friend;
}else{
	$friend = "";
}

sub Answer{
	$parsed = 0;
	while ($parsed == 0){
		sleep(0.5);
		$mech->get("https://www.kingsofkingdoms.com".$URLSERVER."signup.php".$friendurl);
		$a = $mech->content();
		if($a =~ m/Signup now/){
			$parsed = 1;
		}else{
			print "failed to parse page\n";
			sleep(10);
			exit();
		}
	}
	$b = $a;
	$b =~ s/(.*)(Simple Automatism Protection)//sg; #remove before
	$b =~ s/\?.*//s; #remove after
	$b =~ m/(=".*">)/s;
    $c = $1;
	$c =~ s/="//;
	$c =~ s/">//;
	$c =~ s/ /</;
	$c =~ s/ />/;
	$c =~ m/(.*<)/s;
	my $firstnumber = $1;
	#print "$firstnumber\n";
	$firstnumber =~ s/<//;
	$c =~ m/(>.*)/s;
	my $secondnumber = $1;
	#print "$secondnumber\n";
	$secondnumber =~ s/>//;
	$c =~ m/(<.*>)/s;
	my $sumaction = $1;
	#print "$sumaction\n";
	$sumaction=~ s/<//;
	$sumaction=~ s/>//;
	if($sumaction eq "/"){
		$answer = $firstnumber / $secondnumber;
	}
	if($sumaction eq "*"){
		$answer = $firstnumber * $secondnumber;
	}	
	if($sumaction eq "+"){
		$answer = $firstnumber + $secondnumber;
	}
	if($sumaction eq "-"){
		$answer = $firstnumber - $secondnumber;
	}
	($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
	if ($mergernumber == 1){
		$user = $username;
		$char = $charname;
	}else{
		$user = ("$username"."$userinc");
		$char = ("$charname"."$charinc");
	}
	$mech->form_number(0);
	$mech->field("username", $user);
	$mech->field("password", $password);
	$mech->form_number(1);
	$mech->select("sex", $sex);
	$mech->field("charname", $char);
	$mech->select("race", $race);
	$mech->form_number(2);
	$mech->field("isap", $answer);
	$mech->click();
	$aa = $mech->content();
	$ab = $mech->content();
	$ac = $mech->content();
	sleep(0.5);
	if($aa =~ m/already taken/){
		print "[$mergernumber]:[$Hour:$Minute:$Second]: username: $user and/or charname: $char is already in use.\n";
		open(FILE, ">>$filefix mergeraccountslist.txt")
		or die "failed to open file!!!!";
		print FILE "[$mergernumber]:[$Hour:$Minute:$Second]: username: $user and/or charname: $char is already in use.\n";
		close(FILE);
	}
	if($ab =~ m/Some fields/){
		print "[$mergernumber]:[$Hour:$Minute:$Second]: some form fields wrong\n";
		open(FILE, ">>$filefix mergeraccountslist.txt")
		or die "failed to open file!!!!";
		print FILE "[$mergernumber]:[$Hour:$Minute:$Second]: some form fields wrong\n";
		close(FILE);
	}
	if($ac =~ m/ATTENTION/){
		print "[$mergernumber]:[$Hour:$Minute:$Second]:created char:$char	\n";
		open(FILE, ">>$filefix mergeraccountslist.txt")
		or die "failed to open file!!!!";
		print FILE "[$mergernumber]:[$Hour:$Minute:$Second]:username :$user	";
		print FILE "password :$password	";
		print FILE "Charname :$char	\n";
		close(FILE);
	}
	if($ac =~ m/ATTENTION/){
		open(FILE, ">>$filefix formattedmergers.txt")
		or die "failed to open file!!!!";
		print FILE "$user ";
		print FILE "$password\n";
		close(FILE);
	}
}

	$mech = WWW::Mechanize->new();
	$mech->agent_alias( 'Windows Mozilla' );
	
while($mergernumber >= 1){
	&Answer;
	$mergernumber = $mergernumber - 1;
	$userinc++;
	$charinc++;
	while($mergernumber == 0){
		sleep(60);
		print "Account Creation finished"
	}
}