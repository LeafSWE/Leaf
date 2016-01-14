#!/usr/bin/perl -w

use strict;

my $glos = "glos.txt";
open(FILE, "<$glos") || die "File not found";
my @glossario = <FILE>;
close(FILE);
foreach my $x (@glossario) {
	$x =~ s/\n//g;
}

my $file = $ARGV[0];
open(FILE, "<$file") || die "File not found";
my @lines = <FILE>;
close(FILE);
my $i=0;
my @newlines;
foreach(@lines) {
	foreach my $word (@glossario){
		$_ =~ s/^$word$/\\gls{$word}\\g/g;
	}
	push(@newlines,$_);
}

open(FILE, ">$file") || die "File not found";
print FILE @newlines;
close(FILE);

