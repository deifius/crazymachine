#!/usr/bin/perl

open(FILE, "<noteweights.txt") or die "couldn't open noteweights.txt:  $!";
ca@roughscale = <FILE>;
close(FILE);
foreach $note (@roughscale){
	chomp($note);
}
#My job is to add the resonance list built with numericresonator.pd
#to the big chord in noteweights.  I have a modified decoherence subroutine in here.
#eventually decoherence needs to be it's own function, with ARGUMENTS!
#still required- a reaping method. A divining scissor. 
$size = $#roughscale;
%castingnet;
for ($loopx = 0; $loopx <= $size; $loopx++){
	@used = split /\t/, $roughscale[$loopx]; 
	$castingnet{$used[0]} = $used[1];
	#print "$used[0] = $castingnet{$used[0]}\n";
}
@roughscale = keys %castingnet;
#now we have %castingnet == %noteweights.
#foreach $el (@thing) {print "$el\n";}
open (FILE, "<resonances.txt") or die "couldn't open resonances.txt: $!";
@sympathytones = <FILE>;
close(FILE);
print "\n*********************\n";
@sympathytones = sort{$a<=>$b} @sympathytones;
foreach $sympathy (@sympathytones){
	$sympathy =~ s/\;//;
	chomp($sympathy);
	foreach $note (@roughscale){
		if (abs($sympathy - $note) < .98){
			#print "$note = $castingnet{$note}\t";
			$newweight = $castingnet{$note};
			$newweight++;
			#print "HERE $newweight\n";
			if ($newweight == "0"){next;}
			$newnote = (($note*$castingnet{"$note"})+$sympathy)/$newweight;
			$castingnet{"$newnote"} = "$newweight";
			delete $castingnet{"$note"};
			print "OK\t$newnote\t$newweight\n";
			shift @roughscale;
		}else{
			$castingnet{"$sympathy"} = "1";
			#print "NOT\t$note\t$castingnet{$sympathy}\n";
			shift @roughscale;
		}
		@roughscale = keys %castingnet;
	}
}
@roughscale = keys %castingnet;
@roughscale = sort{$a<=>$b}@roughscale;
open(FILE, ">newweights.txt") or die "can't create newweights.txt: $!";
foreach $degree (@roughscale){
	print FILE "$degree\t$castingnet{$degree}\n"
}
close (FILE);
