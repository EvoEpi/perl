#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Sort::Naturally;
use Statistics::PointEstimation;

my $in;
my $col;
my $conf;
my $out;
my $help;

if (@ARGV > 0) {
	GetOptions (
		'in:s' => \$in,
		'col:s' => \$col,
		'conf:s' => \$conf,
		'out:s' => \$out,
		'help' => \$help
	);
}
if ($help) {
	print "Usage:
		--in=\"Name of outfile from bedtools intersect\"
		--col=\"A comma separated list of values specifying columns to parse.
			First three values specify window (i.e., chr,beg,end) and the last value
			(fourth in list) specifies metric to estimate	mean and CI. E.g., 0,1,2,6\"
		--conf=\"Confidence level. E.g., 95 for 95% CI\"
		--out=\"File name of outfile to write to\"\n";
	exit;
}

my %hoa;

open IN, "<$in" or die;
open OUT, ">$out" or die;

while (<IN>) {
	chomp;
	my @array = split "\t";
	my @col = split ",", $col;
	my $win = $array[$col[0]]."\t".$array[$col[1]]."\t".$array[$col[2]];
	my $val = $array[$col[3]];
	if ($val eq ".") {
		$val = "0";
		push @{$hoa{$win}}, $val;
	}
	else {
		push @{$hoa{$win}}, $val;
	}
}

print OUT "chr\tstart\tstop\tmean\tlwr\tupr\n";

foreach (nsort keys %hoa) {
	my $stats = new Statistics::PointEstimation;
	$stats->set_significance($conf);
	$stats->add_data(@{$hoa{$_}});
	if ($stats->mean() == 0) {
		print OUT $_, "\t", "0", "\t", "0", "\t", "0", "\n";
	}
	elsif (scalar @{$hoa{$_}} == 1) {
		print OUT $_, "\t", $stats->mean(), "\t", "0", "\t", "0", "\n";
	}
	else {
		print OUT $_, "\t", $stats->mean(), "\t", $stats->lower_clm(), "\t", $stats->upper_clm(), "\n";
	}
}

close (IN);
