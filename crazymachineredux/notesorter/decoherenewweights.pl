#!/usr/bin/perl

open(FILE, "<newweights.txt") or die "I failed:  $!";
@notelist = <FILE>;
close(FILE);

#to get a hash; $notelist values(2n) as keys, $notelist values (2n+1) as values.
#provided $notelist(2n+1) > 1.  THis is a threshold that may be steepened
%noteweights;
foreach $val(@notelist){
	@splitted = split /\t/, $val;
	chomp($splitted[1]);
	if($splitted[1]>1){
		$noteweights{$splitted[0]} = $splitted[1];
		print "$splitted[0]\t$noteweights{$splitted[0]}\t\n";
	}
}
@notekey = keys %noteweights;
#@notekey = sort { $a <=> $b } @notekey;
foreach $unit(@notekey){print "$unit = $noteweights{$unit}\n";}
sub decohere{
#this loop compares adjacent notes in the key, if they are within range of each other,
#they are combined into one new keynote, with a cumulative weight.
#this routine is a gravity like effect. 
#range is specified by argument.
	@notekey = keys %noteweights;
	@notekey = sort { $a <=> $b } @notekey;
	$listlength = @notekey;
	$decoherenceval = "0";
	for ($len = 0; $len < $listlength; $len++){
		if (abs($notekey[$len+1] - $notekey[$len]) > $_[0]){
			# a weighted average of the 2 keys
			$newweight = $noteweights{$notekey[$len]} + $noteweights{$notekey[$len+1]};
			if ($newweight == "0"){next;}
			$newnote = ($notekey[$len]*$noteweights{$notekey[$len]} + $notekey[$len+1]*$noteweights{$notekey[$len+1]}) / $newweight;
			$noteweights{"$newnote"} = "$newweight";
			#print "$newnote\t$noteweights{$newnote}\n";
			delete $noteweights{"$notekey[$len]"};
			delete $noteweights{"$notekey[$len+1]"};
			$decoherenceval++;
			}	
	}
	$decoherenceval; # decohere returns the number of keys that were merged.
}
for ($mof = .1; $mof < .3; $mof += .1){
	$chang = &decohere($mof);
	print "decoher value:\t$chang\n";
	#make it like popcorn, with a bell curve!
}
@notekey = keys %noteweights;
foreach $value (@notekey){
	if ($noteweights{"$value"} == 1){
		delete $noteweights{"$value"};
	}
} 	
@notekey = keys %noteweights;
@notekey = sort { $a <=> $b } @notekey;
#the following line is a test
#foreach $name (@notekey) {print "$name\t $noteweights{$name}\n";}
open (FILEOUT, ">key.txt") or die "sorry I fucked up:  $!";
print FILEOUT "THIS IS THE KEY!!!!\n";
foreach $name (@notekey) {print FILEOUT "$name\t $noteweights{$name}\t\n";}
close FILEOUT;
