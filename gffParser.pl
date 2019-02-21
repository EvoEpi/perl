#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Sort::Naturally;

my $id;
my $trim_id;
my $gff;
my $trim_att;
my $type;
my $out;
my $help;

if (@ARGV > 0) {
	GetOptions (
		'id:s' => \$id,
		'trim_id:s' => \$trim_id,
		'gff:s' => \$gff,
		'trim_att:s' => \$trim_att,
		'type:s' => \$type,
		'out:s' => \$out,
		'help' => \$help
	);
}
if ($help) {
	print "Usage:
		--id=\"A text file of ID's to search for in GFF[3] (one per line).\"
		--trim_id=\"A string of characters to trim off the end of the ID's.
								Everything to left of this string will be trimmed too.
								For special characters, square brackets (e.g., [.]).
								If nothing is to be trimmed, put <none>.\"
		--gff=\"A GFF[3] file to parse.\"
		--trim_att=\"A string of characters to trim off the end of the attribute.
								Everything to left of this string will be trimmed too.
								\"ID=\" is automatically trimmed.
								For special characters, square brackets (e.g., [.]).
								If nothing is to be trimmed, put <none>.
		--type=\"Type of feature.\"
		--out=\"Name of outfile (will be in bed format).\"\n";
	exit;
}

open ID, "<$id" or die;
open GFF, "<$gff" or die;
open OUT, ">$out" or die;

my %id_hash;
my %att_hoa;

while (<ID>) {
	chomp;
	if ($trim_id eq "none") {
		$id_hash{$_} = 0;
	}
	else {
		$_ =~ s/$trim_id.*//g;
		$id_hash{$_} = 0;
	}
}

while (<GFF>) {
	next if $_ =~ /^#/;
	chomp;
	my ($seqid, $source, $typef, $start, $end, $score, $strand, $phase, $attributes) = split "\t";
	if ($typef eq $type) {
		if ($trim_att eq "none") {
			push @{$att_hoa{$attributes}}, $seqid."\t".$start."\t".$end;
		}
		else {
			$attributes =~ s/ID=|$trim_att.*//g;
			push @{$att_hoa{$attributes}}, $seqid."\t".$start."\t".$end;
		}
	}
}

foreach (keys %id_hash) {
	if (exists $att_hoa{$_}) {
		foreach my $i (@{$att_hoa{$_}}) {
			print OUT $i, "\t", $_, "\n"
		}
	}
}
