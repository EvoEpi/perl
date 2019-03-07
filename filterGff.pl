#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my $id;
my $gff;
my $out;
my $help;

if (@ARGV > 0) {
	GetOptions (
		'id:s' => \$id,
		'gff:s' => \$gff,
		'out:s' => \$out,
		'help' => \$help
	);
}

if ($help) {
	print "Usage:
		--id=\"A text file of ID's to search for in GFF (one per line).\"
		--gff=\"A GFF file to parse.\"
		--out=\"Name of outfile (will be in GFF format with order maintained).\"\n";
	exit;
}

open ID, "<$id" or die;
open GFF, "<$gff" or die;
open OUT, ">$out" or die;

my %h_id;
my %hoh_gff;
my %h_filter;

while (<ID>) {
	chomp;
	$_ =~ s/-.*//g;
	$h_id{$_} = 0;
}

while (<GFF>) {
	next if $_ =~ /^#/;
	chomp;
	my (undef, undef, undef, undef, undef, undef, undef, undef, $attributes) = split "\t";
	my $id = $attributes =~ s/ID=|[-|;].*//rg;
  $hoh_gff{$id}{$.} = $_;
}

foreach my $i (keys %h_id) {
  if (exists $hoh_gff{$i}) {
		foreach my $j (keys %{$hoh_gff{$i}}) {
			$h_filter{$j} = $hoh_gff{$i}{$j};
		}
  }
}

foreach (sort {$a<=>$b} keys %h_filter) {
		print OUT $h_filter{$_}, "\n";
}
