#!usr/bin/perl

### split ref seq in 80nt per line

print "2L\n";
open(F, "/home/shervas/genomenexus/referenceseq/Chr2L.fasta") or die "Error reading";
$seq = <F>;
close(F);
chomp($seq);
open(OF, ">>", "/var/www/html/jbrowse/JBrowse-1.12.0/datatest/Chr2L.fasta") or die "Error creating file";
print OF ">2L\n";
for ($i=0; $i<length($seq); $i=$i+80) {
	$segm = substr($seq,$i,80);
	print OF "$segm\n";
}


print "2R\n";
open(F, "/home/shervas/genomenexus/referenceseq/Chr2R.fasta") or die "Error reading";
$seq = <F>;
close(F);
chomp($seq);
open(OF, ">>", "/var/www/html/jbrowse/JBrowse-1.12.0/datatest/Chr2R.fasta") or die "Error creating file";
print OF ">2R\n";
for ($i=0; $i<length($seq); $i=$i+80) {
	$segm = substr($seq,$i,80);
	print OF "$segm\n";
}


print "3L\n";
open(F, "/home/shervas/genomenexus/referenceseq/Chr3L.fasta") or die "Error reading";
$seq = <F>;
close(F);
chomp($seq);
open(OF, ">>", "/var/www/html/jbrowse/JBrowse-1.12.0/datatest/Chr3L.fasta") or die "Error creating file";
print OF ">3L\n";
for ($i=0; $i<length($seq); $i=$i+80) {
	$segm = substr($seq,$i,80);
	print OF "$segm\n";
}

print "3R\n";
open(F, "/home/shervas/genomenexus/referenceseq/Chr3R.fasta") or die "Error reading";
$seq = <F>;
close(F);
chomp($seq);
open(OF, ">>", "/var/www/html/jbrowse/JBrowse-1.12.0/datatest/Chr3R.fasta") or die "Error creating file";
print OF ">3R\n";
for ($i=0; $i<length($seq); $i=$i+80) {
	$segm = substr($seq,$i,80);
	print OF "$segm\n";
}

print "X\n";
open(F, "/home/shervas/genomenexus/referenceseq/ChrX.fasta") or die "Error reading";
$seq = <F>;
close(F);
chomp($seq);
open(OF, ">>", "/var/www/html/jbrowse/JBrowse-1.12.0/datatest/ChrX.fasta") or die "Error creating file";
print OF ">X\n";
for ($i=0; $i<length($seq); $i=$i+80) {
	$segm = substr($seq,$i,80);
	print OF "$segm\n";
}