#!/usr/bin/perl

open(FILE, "<tones.txt") or die "I failed:  $!";
@notelist = <FILE>;
close(FILE);
foreach $note (@notelist){
	chomp($note);
	chop($note);
}
#foreach $note (@notelist){print "$note\n";}

#now we got a list of all the notes, now to make a hash, $notelist values as keys, reoccurrence as weight.

%noteweights;
foreach $note (@notelist){
	#print "$note\n";
	if (exists $noteweights{$note}){
		$noteweights{$note}++;
		#print "old edition";
	}
	else {$noteweights{$note} = "1"; #print "new addition\n"
	} 
}
@notekey = keys %noteweights;
@notekey = sort { $a <=> $b } @notekey;
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
		if ($notekey[$len+1] - $notekey[$len] > $_[0]){
			# a weighted average of the 2 keys
			$newweight = $noteweights{$notekey[$len]} + $noteweights{$notekey[$len+1]};
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
for ($mof = .1; $mof < .9; $mof += .09){
&decohere($mof);
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
open (FILEOUT, ">noteweights.txt") or die "sorry I fucked up:  $!";
foreach $name (@notekey) {print FILEOUT "$name\t $noteweights{$name}\t\n";}
close FILEOUT;
open (FILEOUT, ">coherentcord.txt") or die "sorry I fucked up:  $!";
foreach $name (@notekey) {print FILEOUT "$name\;\n";}
close FILEOUT;
print "0";


