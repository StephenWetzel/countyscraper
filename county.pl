#!/usr/bin/perl
#County data scrapper by Stephen Wetzel Aug 21 2014
#requires lynx
#http://livingwage.mit.edu/

use strict;
use warnings;
use autodie;

#$|++; #autoflush disk buffer


my $testing = 0; #set to 1 to prevent actual downloading, 0 normally
my $outfile = "counties.csv";


my $temp;
my $state;
my @fileArray; #stores lines of input files
my $thisLine; #store individual lines of input file in for loops

open my $ofile, '>', $outfile;
for (my $ii = 1; $ii <= 65; $ii++)
{
	$temp = "wget \"http://livingwage.mit.edu/states/".sprintf("%02d", $ii)."/locations\" -O - > temp.html";
	if (!$testing) {system($temp);} #download page when not testing
	
	open my $ifile, '<', "temp.html";
	@fileArray = <$ifile>;
	close $ifile;
	foreach $thisLine (@fileArray)
	{#go through the linx dump, gather data
		if ($thisLine =~ m/Counties and Places in ([\w|\s]+)/)
		{
			$state = $1;
		}
		
		
		#<li><a href="/counties/05013">Calhoun County</a></li>
		if ($thisLine =~ m/<li><a href="\/counties\/(\d{5})">([\w|\s]+)<\/a>/)
		{#this line should contain a date
			print $ofile "\n$1; $2; $state";
		}
	}
	
	
	
}


close $ofile;
print "\nDone\n\n";
