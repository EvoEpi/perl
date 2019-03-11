# perl
A collection of Perl scripts for handling various data files.

`filterGff.pl`. Filters a GFF file generated by `MAKER` based on a list of ID's. GFF file order is maintained in the filtered GFF.

Usage:

```bash
perl filterGff.pl \
--id=<text file of ids> \
--gff=<gff file> \
--out=<name of outfile (will be in gff format)>
```

`gffParser.pl`. This script will parse a GFF\[3\] file based on a list of ID's and type of feature. The output will be written to a file in BED format. 

Usage:

```bash
perl gffParser.pl \
--id=<text file of ids> \
--trim_id=<a string of characters to trim off the end of the ids> \
--gff=<gff file> \
--trim_att=<a string of characters to trim off the end of the attribute> \
--type=<type of feature, e.g., CDS> \
--out=<name of outfile (will be in bed format)>
```

`meanCIperWin.pl`. This script will calculate the mean and confidence interval (CI) based on a genomic window. As input `meanCIperWin.pl` requires a file generated from the [bedtools](https://bedtools.readthedocs.io/en/latest/) intersection of a "windows" bed file generated from [bedtools](https://bedtools.readthedocs.io/en/latest/) makewindows ([usage examples](http://seqanswers.com/forums/archive/index.php/t-17627.html)) and either a vcf or bed file (e.g., pi/site file generated by [vcftools](http://vcftools.sourceforge.net/)). The script allows the user to set what columns in the infile to use for the window (with some restrictions) and what column to calculate mean and CI (of user's choice).

Usage:

```bash
perl meanCIperWin.pl --in=<infile> --col=<e.g., 1,2,3,6> --conf=<e.g., 95> --out=<outfile>
```

`pfamFromFasta.pl`. This script will extract the [Pfam](https://pfam.xfam.org/) protein functional domain, as identified by [InterProScan](https://www.ebi.ac.uk/interpro/interproscan.html), from nucleotide or amino acid sequences. From your working directory, the script will loop through all files ending in .fa, .faa, .fas, .fna, and .fasta and .iprscan.tsv. Extracting protein functional domains is particularly useful for phylogenetic analyses, especially when including gene or protein sequence from deeply diverged species. 

Usage:

```bash
perl pfamFromFasta.pl --pfam=<pfam domain id, e.g., PF00145> --seqtype=<nucl|prot> --out=<outfile>
```
