#!/usr/bin/perl

#this is a protoype for massresonance.pl.  kept for archival purposes
#and to avoid implement regexes.
open(FILE, "<noteweights.txt") or die "I failed:  $!";
@roughscale = <FILE>;
close(FILE);
foreach $note (@roughscale){
	$note =~ s/\;/5/;
	chomp($note);
}
$size = $#roughscale;
%castingnet;
for ($loopx = 0; $loopx <= $size; $loopx++){
	@used = split /\t/, $roughscale[$loopx];
	$castingnet{$used[0]} = $used[1];
	#print "$used[0] = $castingnet{$used[0]}\n";
}
#now we have %castingnet == %noteweights.
#foreach $el (@thing) {print "$el\n";}
@harmonics = qw(2 .5 1.5 .6666667 1.3333333 .75 1.25 .8 1.2 .888888889 .9 1.1111111 1.06666667 .9375);

sub freq2midi {
	$midiout = 8.17579891564*2.71828^(0.0577622650*$_[0]);
	$midiout;
}
sub midi2freq {
#	$freqout = 17.3123405046*log(.122312205085*$_[0]);
#	$freqout;
}
#these subroutines are totally bogus!
#they're not even used here, I implemented them in PD 
#######real easy
@addedtones;
@roughscale = keys %castingnet;
foreach $name (@roughscale){print "$name\n";}

foreach $midinote (@roughscale){
	foreach $harmonic (@harmonics){
		push @addedtones, ($harmonic * ($castingnet{$midinote}));
		$freq1 = &midi2freq($castingnet{$midinote});
		$freq2 = $harmonic * $freq1;
		#$thing = &freq2midi($harmonic * &midi2freq($midinote));
		#print "$freq1 X $harmonic = $freq2\n";
	}
}
@addedtones = sort { $a <=> $b } @addedtones;

