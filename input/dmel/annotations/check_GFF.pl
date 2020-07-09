#!/usr/bin/perl

use warnings;

open(F, "dmel_genes_features.gff") or die "Error reading\n";   ################# FILE WITH ONLY GENES AND MRNA (must create)
@f = <F>;
close(F);

foreach $el (@f) { #read line by line

	@line = split("\t",$el); #save each line in array

	$info = $line[8];
	@info2 = split(";",$info);

	
	@name = grep { $_ =~ /Name=/ } @info2; #grep names (Name=)
	if (@name) {
		$name1 = $name[0];
		$name2 = $name1;
		$name2 =~ s/Name=//g;
		#print "$name2\n";
	}

	@nameID = grep { $_ =~ /ID=/ } @info2; #grep names (ID=) for mRNAs
	if (@nameID) {
		$nameID1 = $nameID[0];
		$nameID2 = $nameID1;
		$nameID2 =~ s/ID=//g;
		#print "$nameID2\n";
	}

	@parents = ($name2,$nameID2);
	push @listparents, @parents; #add to a new array!
}

## keep unique values in array
%seen = ();
@uniqu = grep { ! $seen{$_} ++ } @listparents;
#$l = @uniqu;
#print "$l\n";



####### READ GFF LINE BY LINE AND KEEP THOSE WITH A MATCH IN @uniqu 

open (OF, ">>dmel_filtered_parents.gff") or die "Error writting\n"; #create new file
foreach $el (@f) {

	@id = grep { $_ =~ /Parent=/ } @info2; #grep parents of each feature

	if (@id) {
		$id1 = $id[0];
		$id2 = $id1;
		$id2 =~ s/Parent=//g;
		#print "$id2\n";

		if (grep ($id2, @uniqu)) {
			#print "$id2 Found!\n";
			print OF "$el";

		}
	}
}
close(OF);


##### after that, bash command to join gff_header.gff and dmel_filtered_parents.gff
### cat gff_header.gff dmel_filtered_parents.gff > dmel_filtered_parents_DEF.gff

########### DATATEST.sh --> prepare many files!!!