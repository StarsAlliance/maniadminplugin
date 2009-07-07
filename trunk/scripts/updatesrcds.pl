#!/usr/bin/perl

use Cwd;

# Updates the default Valve Source engined games.

sub update_game;


if ($^O eq "MSWin32")
{
	print "Windows platform\n";
	$ROOT_PATH="C:/MyDev";
	$UPDATER="HldsUpdateTool.exe";
	$linux=false;
}
else
{
#Linux platform
	print "Linux platform\n";
	$ROOT_PATH='$HOME/MyDev';
	$UPDATER="./steam";	
	$linux=true;
}

$SRCDS_PATH="$ROOT_PATH/srcds_1";

#Add new games here with their Valve game names
%game_cmd = (
"Counter-Strike Source"		=> "Counter-Strike Source",
"Half-Life 2 Deathmatch" 	=> "hl2mp",
"Team Fortress 2" 		=> "tf",
"Day of Defeat Source" 		=> "dods"
);


print "\n";

$count=1;
for my $key ( sort keys %game_cmd ) 
{
	my $value = $game_cmd{$key};
        print "$count - $key\n";
        $count = $count + 1;
}

print "\nChoose a game to update or type \"all\" to update all games\n\n";

$question_response = <>;
chomp($question_response);
chdir ($SRCDS_PATH);

my $dir = getcwd();

print "Current path = $dir\n";

if ($question_response eq "all")
{
	for my $key ( sort keys %game_cmd ) 
	{
		my $value = $game_cmd{$key};
		update_game($value);
	}
}
else
{
	$count=1;
	for my $key ( sort keys %game_cmd ) 
	{
		if ($count eq $question_response)
		{
			my $value = $game_cmd{$key};
			update_game($value);
		}	        
	        $count = $count + 1;
	}	
}



sub update_game
{
	if (! -e $UPDATER)
	{
		# No installation found
		if ($linux == true)
		{
			# Download the hlds updater tool and run it
			system("wget http://www.steampowered.com/download/hldsupdatetool.bin");
			system("chmod +x hldsupdatetool.bin");
			system("./hldsupdatetool.bin");
			system("./steam");
		}
		else
		{
			# Windows 
			print "You need to download the following file to the srcds_1 folder 'http://www.steampowered.com/download/hldsupdatetool.exe'";
			exit;
		}
	}

	print "Perl script - Updating Game $_[0]\n";
	$system_command="$UPDATER -command update -game \"$_[0]\" -dir $SRCDS_PATH";
	system($system_command);
}

