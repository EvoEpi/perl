# perl
A collection of Perl scripts for handling various data files.

`meanCIperWin.pl`. This script will calculate the mean and confidence interval (CI) based on a genomic window. As input `meanCIperWin.pl` requires a file generated from the [bedtools](https://bedtools.readthedocs.io/en/latest/) intersection of a "windows" bed file generated from [bedtools](https://bedtools.readthedocs.io/en/latest/) makewindows ([usage examples](http://seqanswers.com/forums/archive/index.php/t-17627.html)) and either a vcf or bed file (e.g., _pi_/site file generated by [vcftools](http://vcftools.sourceforge.net/)). The script allows the user to set what columns in the infile to use for the window (with some restrictions) and what column to calculate mean and CI (of user's choice).

Usage:

```bash
perl meanCIperWin.pl --in=<infile> --col=<e.g., 1,2,3,6> --conf=<e.g., 95> --out=<outfile>
```
