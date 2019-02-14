#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Sort::Naturally;

my $pfam;
my $seqType;
my $out;
my $help;

if (@ARGV > 0) {
	GetOptions (
		'pfam:s' => \$pfam,
		'seqtype:s' => \$seqType,
		'out:s' => \$out,
		'help' => \$help
	);
}
if ($help) {
	print "Usage:
		--pfam=\"Name of PFAM domain to search for in iprscan file(s). E.g., 'PF00145'\"
		--seqtype=\"The type of sequence you are extracting the domain from ('nucl' or 'prot')\"
		--out=\"Fasta file name of outfile to write to\"\n";
	exit;
}

open OUT, ">$out" or die;

my $h; #header
my $s; #seq
my %m; #model
my $c; #count

#read and store all files ending with .fa, .faa, .fas, .fna and .fasta in an array
my @fastaFiles = glob ("*.fa *.faa *.fas *.fna *.fasta");

#loop over files
foreach my $file (@fastaFiles) {
    open FASTA, "<$file";
    while (<FASTA>) {
        chomp;
        if ($_ =~ /^>(.*)/) {
            if ($s) {
                $h =~ s/ .*//g;
                foreach my $n (split //, $s) {
                    $c++;
                    $m{$h}{$c} = $n;
                }
            }
            $h = $1;
            $s = '';
        }
        else {
            $s .= $_;
        }
        $c = 0;
    }
    $h =~ s/ .*//g;
    foreach my $n (split //, $s) {
        $c++;
        $m{$h}{$c} = $n;
    }
}

#read and store all files ending with *.iprscan.tsv in an array
my @iprscanFiles = glob ("*.iprscan.tsv");

my %hoh;

#loop over files
foreach my $file (@iprscanFiles) {
    open IPRSCAN, "<$file";
    while (<IPRSCAN>) {
        chomp;
        my @a = split "\t";
        if ($a[4] eq $pfam) {
            $hoh{$a[0]}{$a[6]."\t".$a[7]} = $a[5];
        }
        else {
            next;
        }
    }
}

foreach (sort keys %hoh) {
	if (exists $m{$_}) {
		foreach my $d (nsort keys %{$hoh{$_}}) {
			my ($start, $stop) = split "\t", $d;
			print OUT ">$_ $hoh{$_}{$d} $start $stop\n";
			foreach my $p (sort {$a <=> $b} keys %{$m{$_}}) {
				if ($seqType eq "nucl") {
					if ($p >= $start*3-2 and $p <= $stop*3) {
						print OUT $m{$_}{$p};
					}
				}
				elsif ($seqType eq "prot") {
					if ($p >= $start and $p <= $stop) {
						print OUT $m{$_}{$p};
					}
				}
			}
      print OUT "\n";
    }
  }
}
