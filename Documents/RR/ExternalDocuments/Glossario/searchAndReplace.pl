#!/usr/bin/perl -w
use XML::LibXML;
use strict;

my $file = "Glossario.xml";
my $parser=XML::LibXML->new();                      #creazione del parser
my $doc=$parser->parse_file($file) || die("file non trovato \n");   #parsing del file
my $root=$doc->getDocumentElement;                  #estrazione radice
my @voci = $root->getElementsByTagName("voce");

$file = $ARGV[0];
open(FILE, "<$file") || die "File not found";
my @lines = <FILE>;
close(FILE);
my @newlines;
foreach my $x (@lines) {
    foreach my $voce (@voci) {
        my $word = $voce->findvalue("termine");
        $word =~ s/^\s+|\s+$//g;
        #$x =~ s/$word/\\gls{$word}\\g/g;
        $x =~ s/$word /$word\\g\\ /i;
        $x =~ s/$word,/$word\\g,/i;
        $x =~ s/$word\./$word\\g./i;
        $x =~ s/$word;/$word\\g;/i;
        $x =~ s/$word:/$word\\g:/i;
        $x =~ s/$word\s/$word\\g\\ \n/i;
        
        $x =~ s/$word\]/$word\\g\]/i;
        #$x =~ s/$word[\}][^\\g]/\\gls{$word}\\g\}/g;
        $x =~ s/$word\)/$word\\g\)/i;
    }
    push(@newlines,$x);
}
my $newfile = join("", @newlines);
open(FILE, ">$file") || die "File not found";
print FILE $newfile;
close(FILE);
