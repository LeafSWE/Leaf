#!/usr/bin/perl -w
use XML::LibXML;
use strict;

my $file = "Glossario.xml";
my $parser=XML::LibXML->new();                      #creazione del parser
my $doc=$parser->parse_file($file) || die("file non trovato \n");   #parsing del file
my $root=$doc->getDocumentElement;                  #estrazione radice
my @voci = $root->getElementsByTagName("voce");
my $newfile = "\\documentclass[a4paper]{article}
\\usepackage{leaf}
\\usepackage[nonumberlist]{glossaries}
\\titlepage{}
\\intestazioni{Glossario}\n";
foreach my $voce (@voci) {
    my $termine = $voce->findvalue("termine");
    $termine =~ s/\s+//;
    my $descrizione = $voce->findvalue("descrizione");
    $descrizione =~ s/\n//;
    $newfile = $newfile."\\newglossaryentry{$termine}{name=$termine,description={$descrizione}}\n";
}

$newfile = $newfile."\\makeglossaries


\\begin{document}
	\\begin{titlepage} 
		\\centering
		{\\huge\\bfseries CLIPS\\par}
		Communication \\& Localization with Indoor Positioning Systems \\\\*
		\\line(1,0){350} \\\\
		%\\includegraphics[width=0.15\\textwidth]{example-image-1x1}\\par\\vspace{1cm}
		{\\scshape\\LARGE Universit\\`a{} di Padova \\par}
		\\vspace{1cm}
		{\\scshape\\Large Norme di progetto\\par}
		\\vspace{2cm}
		\\begin{center}
		{\\includegraphics[height=10em]{logoNoSfondo} \\DeclareGraphicsExtensions{.png}\\par}
		\\end{center}
		\\vfill \\vfill
		\\begin{tabular}{c|c}
			{\\hfill \\textbf{Versione}} 			& 1.00			\\\\ \\\\
			{\\hfill\\textbf{Data Redazione}} 		& 2015-12-24  		\\\\ \\\\
			{\\hfill\\textbf{Redazione}} 			&  Marco Zanella      \\\\ \\\\
			{\\hfill\\textbf{Verifica}} 				&  \\\\ \\\\
			{\\hfill\\textbf{Approvazione}} 		&  \\\\ \\\\
			{\\hfill\\textbf{Uso}} 					& \\\\ \\\\
			{\\hfill\\textbf{Distribuzione}} 			& \\\\ \\\\
		\\end{tabular}
	\\end{titlepage}
\\pagestyle{mymain}

\\glsaddall
\\printglossary[style=indexgroup, nonumberlist]
\\label{LastPage}
\\end{document}";

$file = "Glossario.tex";
open(OUT, ">$file");                            #apertura file 
print OUT $newfile;                       #serializzazione + salvataggio
close(OUT);