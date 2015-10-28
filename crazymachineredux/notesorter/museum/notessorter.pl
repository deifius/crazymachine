!#/usr/bin/perl
open (RAWNOTES, "<tones.txt") or die "couldn't do it: $! \n";
$notelist = <RAWNOTES>;
close RAWNOTES;
@notes = split /\s+/, $notelist;
#decohere note clusters into notes, specify a hash with weights
foreach $note (@notes){
	@notekey = keys %noteweights;
	foreach $notekey (@notekey){
		if ($notekey == $note){
			$noteweights{"$note"} = $noteweights{"$note"} + 1;
			}
	else {%noteweights = ("$note" => "1");}
	}
}
@notekey = sort { $a <=> $b } @notekey;

sub decohere{
#this loop compares adjacent notes in the key, if they are within range of each other,
#they are combined into one new keynote, with a cumulative weight.
#this routine is a gravity effect. 
#range is specified by argument.
	$listlength = @notekey;
	$decoherenceval = "0";
	for ($len = 0; $len < $listlength; $len++){
		if ($notekey[$len+1] - $notekey[$len] > $_[0]){# a weighted average of the 2 keys
			$newweight = $noteweights{$notekey[$len]} + $noteweights{$notekey[$len+1]};
			$newnote = ($notekey[$len]*$noteweights{$notekey[$len]} + $notekey[$len+1]*$noteweights{$notekey[$len+1]}) / $neweight;
			%noteweights = ("$newnote" => "$newweight");
			delete $noteweights{$notekey[$len]};
			delete $noteweights{$notekey[$len+1]};
			$decoherenceval++;
			}	
	}
	$decoherenceval; # decohere returns the number of keys that were merged.
}
$scalesize = 24; #number of destinct pitches to resolve to
$resolution = .01;
&decohere($resolution);
while($listlength > $scalesize){
	$resolution += .01;
	$work = &decohere($resolution);
	if ($work = 0){$resolution = $resolution * 2;#a timesaving measure
	}
}
#now compare notes by weight and harmonic relation
#########but not of midi!!!!  implement midi2freq and freq2midi to do this right############
#########sleepy time#########
sub midi2freq {
	$midiout = 8.17579891564*2.71828^(0.0577622650*$_[0]);
	$midiout;
}
sub freq2midi {
	$freqout = 17.3123405046*log(.122312205085*$_[0]);
	$freqout;
}

#first sort notes according to the notes associated weight
@notepresence = keys %noteweights;
@notepresence = sort { $noteweights{$a} <=> $noteweights{$b} } @notepresence; 
foreach $val (@notepresence) { $val = &midi2freq($val);}

#now add harmonic resonance of each element to the weight table
foreach $notepresent (@notepresence){
	@harmonicseries = ("3/2", "4/3", "5/4", "9/8");#...and the other harmonics which escape me right now
	foreach $harmony (@harmonicseries){
		if(exists $noteweights{&freq2midi($notepresent*$harmony)}){ 
			$noteweights{$notepresent*$harmony} = $noteweights{$notepresent*$harmony}+1;
		}else{ 
			%noteweights = "&freq2midi($notepresent*$harmony)" => "1";
		}
	}
}
#decohere, until we arrive at a semblance of a scale

