#!/usr/bin/perl      
# The first line of the script envokes Perl 
# Use "/usr/bin/perl -w" option for debugging

use strict;
use warnings;

use File::chdir; #provides $CWD variable for manipulating working directory
use Term::ReadKey;

# This script will act as command line utility to perform following tasks
# Change the directory
# Open an applications
# Display a particular directory

#save home directory in a variable
my $home = $ENV{'HOME'};
#print "Home = $home \n";

my $prompt = 'mogomantra>';
print $prompt;

use constant FALSE => 0;
use constant TRUE  => 1;

# read the commands
my $pathsep = "/";
my @results;
my $cmdName;
my $lastCmdIndex = 0;
my $i=0;
my @cmdList = {};
my $cmdRetValue;
#my $lastCmd;

ReadMode 4;  # Turn off controls keys
while(1) {
	my $key; 
	while (not defined ($key = ReadKey(-1))) {
	   # No key yet
	}
	
	# Capture ^C or ^D keys to exit the interpreter	
	if(ord($key) eq 3 or ord($key) eq 4) {
		print "\n";
		last;
	}
	
	# Capture any other key and create the command
	if (ord($key) != 27) {
	   #print "Got key ".ord($key)."\n";
	   print $key;
	   
	   #Don't add the new line charactor to command
	   if(ord($key) ne 10) {
	   		$cmdName = $cmdName.$key;
	   }
	   
	   # Capture enter key to execute the command
	   if(ord($key) eq 10) {
			$cmdRetValue = &runCommand($cmdName);
			if($cmdRetValue eq FALSE) {
				last;
			}
		   $cmdList[$i++] = $cmdName;
		   $cmdName = "";
		   
		   #Assign the last command index. Perl allows to track array elements in reverse order.
		   $lastCmdIndex = -1;
	   }
	} elsif ($key = ReadKey(-1) and $key ne '[') {
	   print "Not sure what I have...\n"
	} else {
	   $key = ReadKey(-1);
	   if ($key eq 'A') { 
	   		#print "UP pressed.\n";
	   		if($i ge -$lastCmdIndex) {
	   			my $lastCmd = $cmdList[$lastCmdIndex];
	   			print "$lastCmd";
	   			$cmdName = $lastCmd;
	   			$lastCmdIndex--;
	   		}else {
	   			my $lastCmd = $cmdList[0];
	   			print "$lastCmd";
	   			$cmdName = $lastCmd;  			
	   		}
	   	}
	   elsif ($key eq 'B') { 
	   		#print "DOWN pressed.\n"; 
	   		if($i ge -$lastCmdIndex) {
	   			my $lastCmd = $cmdList[$lastCmdIndex];
	   			print "$lastCmd";
	   			$cmdName = $lastCmd;
	   			$lastCmdIndex++;
	   		}else {
	   			my $lastCmd= $cmdList[-$i];
	   			print "$lastCmd";
	   			$cmdName = $lastCmd;
	   		}
	   	}
	   elsif ($key eq 'C') { print "RIGHT pressed.\n" }
	   elsif ($key eq 'D') { print "LEFT pressed.\n" }
	   else { print "Not sure what I have...\n" }
	}
	#print $prompt;
}

ReadMode 0; # Reset tty mode before exiting

#while(my $commandName = <STDIN>) {
	#&runCommand($commandName)
#}

sub runCommand{
	my ($commandName) = @_;
	#print $commandName;
    chomp $commandName;

    if(length($commandName) gt 0) {
	    if($commandName eq "STOP") {
	    	return FALSE;
	    }
	    elsif($commandName eq "quit") {
	    	return FALSE;
	    }
	    elsif($commandName eq "exit") {
	    	return FALSE;
	    }
	    elsif($commandName eq "bye") {
	    	return FALSE;
	    }
	    elsif($commandName eq "ls projects") {
	    	my @values = split(' ', $commandName);
	    	my $cmd = "ls -al $home$pathsep$values[1]";
	    	print "cmd = $cmd\n";
	    	@results = `$cmd`;
	    	print @results;
	    	#last;
	    }
	    elsif((split(' ', $commandName))[0] eq "ls" ) {
		 	my @values = split(' ', $commandName);
	 		my $cmd;
	 		if (@values gt 1) {
		    	if ($values[1] eq "projects") {
			     	$cmd = "ls -al $home$pathsep$values[1]";
			    	print "cmd = $cmd\n";
			    	@results = `$cmd`;
		    		print @results;
		    	}
		    	elsif ($values[1] eq "clients") {
			     	$cmd = "ls -al $home$pathsep"."projects".$pathsep."$values[1]";
			    	print "cmd = $cmd\n";
			    	@results = `$cmd`;
		    		print @results;
		    	}
		    }
	    	else {
	 	     	$cmd = "ls -al ".`pwd`;
		    	print "cmd = $cmd\n";
		    	@results = `$cmd`;
	    		print @results;
	    	}
	    	#last;
	    }
	    elsif((split(' ', $commandName))[0] eq "cd" ) {
		 	my @values = split(' ', $commandName);
	 		my $cmd;
	 		if (@values gt 1) {
		 
		    	if ($values[1] eq "projects") {
			     	$cmd = "$home$pathsep$values[1]";
			    	print "cmd = cd $cmd\n";
			    	chdir($cmd);
		    	}
		    	elsif ($values[1] eq "clients") {
			     	$cmd = "$home$pathsep"."projects".$pathsep."$values[1]";
			    	print "cmd = cd $cmd\n";
			    	chdir($cmd);
		    	}
		    }
		    else {
				$cmd = "$home";
			    print "cmd = cd $cmd\n";
			    chdir($cmd);
		    }
	    	#last;
	    }
	  	elsif($commandName eq "cls") {
	    	my $cmd = "clear";
	    	print "cmd = $cmd\n";
	    	@results = `$cmd`;
	    	print @results;
	    	#last;
	    }
	     else {
	    	my $cmd = "$commandName";
	    	print "cmd = $cmd\n";
		    @results = `$cmd`;
		    print @results;
		    #last;
	    }
    }
    
    print $prompt;
    return TRUE;
}


