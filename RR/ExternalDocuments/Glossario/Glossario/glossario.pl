#!/usr/bin/perl -w
use XML::LibXML;
use strict;

my $file = "Glossario.xml";
my $parser=XML::LibXML->new();                      #creazione del parser
my $doc=$parser->parse_file($file) || die("file non trovato \n");   #parsing del file
my $root=$doc->getDocumentElement;                  #estrazione radice
my @voci = $root->getElementsByTagName("voce");
my $newfile = "\\documentclass[a4paper]{article}
\\usepackage[T1]{fontenc}
\\usepackage[utf8]{inputenc}
\\usepackage[italian]{babel}

\\usepackage{glossaries}\n";
foreach my $voce (@voci) {
    my $termine = $voce->findvalue("termine");
    my $descrizione = $voce->findvalue("descrizione");
    $newfile = $newfile."\\newglossaryentry{$termine}{name=$termine,description={$descrizione}}\n";
}

$newfile = $newfile."\\makeglossaries

\\begin{document}
\\glsaddall
\\printglossary[style=indexgroup]
\\end{document}";

$file = "Glossario.tex";
open(OUT, ">$file");                            #apertura file 
print OUT $newfile;                       #serializzazione + salvataggio
close(OUT);