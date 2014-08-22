#!/usr/bin/perl
#COL data scrapper by Stephen Wetzel Aug 21 2014
#requires lynx
#http://livingwage.mit.edu/

use strict;
use warnings;
use autodie;

#$|++; #autoflush disk buffer


my $testing = 0; #set to 1 to prevent actual downloading, 0 normally
my $infile = "counties.csv";
my $outfile = "col.csv";

my $temp;
my $state;
my @fileArray; #stores lines of input files
my $thisLine; #store individual lines of input file in for loops
my @dumpArray;
my $dumpLine;

open my $ofile, '>', $outfile;

open my $ifile, '<', $infile;
@fileArray = <$ifile>;
close $ifile;
foreach $thisLine (@fileArray)
{
	if ($thisLine =~ m/(\d{5}); ([\w|\s]+); ([\w|\s]+)/)
	{#grab the county info from the input file
		my $state = $3;
		chomp($state);
		my $id = $1;
		my $county = $2;
		
		print "\nDownloading $county $id $state";
		$temp = "lynx -dump -width=9999 -nolist \"http://livingwage.mit.edu/counties/$id/\" > dump.txt";
		print "\n$temp";
		`$temp`;
		
		open $ifile, '<', "dump.txt";
		@dumpArray = <$ifile>;
		close $ifile;
		foreach $dumpLine (@dumpArray)
		{#go through lynx dump and find income data line
			#   Required annual income before taxes $17,251 $36,640          $46,592             $58,109             $27,806  $34,827           $37,727              $43,083
			if ($dumpLine =~ m/\s+Required annual income before taxes \$([\d|\,]+)\s+\$([\d|\,]+)\s+\$([\d|\,]+)\s+\$([\d|\,]+)\s+\$([\d|\,]+)\s+\$([\d|\,]+)\s+\$([\d|\,]+)/)
			{
				#1 Adult 1 Adult, 1 Child 1 Adult, 2 Children 1 Adult, 3 Children 2 Adults 2 Adults, 1 Child 2 Adults, 2 Children 2 Adults, 3 Children
				print $ofile "\n$state; $id; $county; $1; $2; $3; $4; $5; $6; $7";
			}
		}
	}
}

close $ofile;
print "\nDone\n\n";
