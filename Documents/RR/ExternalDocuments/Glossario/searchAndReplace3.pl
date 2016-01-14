#!/usr/bin/perl -w

use strict;

my $glos = "glos.txt";
open(FILE, "<$glos") || die "File not found";
my @glossario = <FILE>;
close(FILE);
foreach my $x (@glossario) {
    $x =~ s/\n//g;
}
foreach my $x (@glossario) {
    print "$x,";
};
my $file = $ARGV[0];
open(FILE, "<$file") || die "File not found";
my @lines = <FILE>;
close(FILE);
my $i=0;
my @newlines;
foreach my $x (@lines) {
    foreach my $word (@glossario){
        #$x =~ s/$word/\\gls{$word}\\g/g;
        $x =~ s/$word[,]/\\gls{$word}\\g,/g;
        $x =~ s/$word[.]/\\gls{$word}\\g./g;
        $x =~ s/$word[;]/\\gls{$word}\\g;/g;
        $x =~ s/$word[\n]/\\gls{$word}\\g\n/g;
        $x =~ s/$word[ ]/\\gls{$word}\\g /g;
        $x =~ s/$word[\]]/\\gls{$word}\\g\]/g;
        #$x =~ s/$word[\}][^\\g]/\\gls{$word}\\g\}/g;
        $x =~ s/$word[\)]/\\gls{$word}\\g\)/g;
    }
    push(@newlines,$x);
}
my $newfile = join("", @newlines);
open(FILE, ">$file") || die "File not found";
print FILE $newfile;
close(FILE);

