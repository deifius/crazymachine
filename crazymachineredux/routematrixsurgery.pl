#!/usr/bin/perl

$file = "$ARGV[0]";
open(FILE, "<$file") or die "couldn't open $file:  $!";
@everyline = <FILE>;
close FILE;

#X obj 160 78 + 12;
# regex pattern is "#X obj .+ \+ 12"

$chicken = 0;
foreach $line(@everyline){
	$line;
	if ($line =~ /#X obj .+ s \\\$0-2yourmother/){
		@words = split /\s+/, $line;
		$words[5] = "\\\$0-2yourmother$chicken;\n";
		$line = join ' ', @words;
		$chicken++;
	}
}

open (OUTPUT, ">$file") or die "couldn't open $file: $!";
$pants = 0;
foreach $line(@everyline){
	print OUTPUT "$line";
	$pants++;
}

print "went through $pants lines of code in $file and found $chicken matching strings\n";
close OUTPUT;
	
