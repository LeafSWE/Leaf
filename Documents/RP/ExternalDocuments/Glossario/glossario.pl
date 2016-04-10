#!/usr/bin/perl -w
use XML::LibXML;
use strict;
use utf8;

my $file = "Glossario.xml";
my $parser=XML::LibXML->new();                      #creazione del parser
my $doc=$parser->parse_file($file) || die("file non trovato \n");   #parsing del file
my $root=$doc->getDocumentElement;                  #estrazione radice
my @voci = $root->getElementsByTagName("voce");
my $newfile = "\\documentclass[a4paper]{article}
\\usepackage{leaf}
\\usepackage[nonumberlist]{glossaries}
\\titlepage{}
\\newglossarystyle{myaltlistgroup}{%
\\setcounter{page}{0}
  \\setglossarystyle{altlistgroup}%
  \\renewcommand*{\\glsgroupheading}[1]{%
   \\newpage
    \\item\\makebox[\\linewidth]{\\Large\\textbf{\\glsgetgrouptitle{##1}}}%
    \\vspace*{-\\baselineskip}%
    \\item\\makebox[\\linewidth]{\\hspace*{3cm}\\hrulefill\\hspace*{3cm}}%
  }%
}
\\renewcommand{\\glossarysection}[2][]{}
\\intestazioni{Glossario}\n";
foreach my $voce (@voci) {
    my $termine = $voce->findvalue("termine");
    $termine =~ s/^\s+|\s+$//g;
    $termine = ucfirst($termine);
    my $descrizione = $voce->findvalue("descrizione");
    $descrizione =~ s/^\s+|\s+$//g;
    $descrizione = ucfirst($descrizione);
    $newfile = $newfile."\\newglossaryentry{$termine}{name=$termine,description={$descrizione}}\n";
}

$newfile = $newfile."\\makeglossaries
\\author{Zanella Marco}
\\date{07/12/2015}
\\intestazioni{Glossario}
\\pagenumbering{gobble}
\\begin{document}
\\begin{titlepage}
	\\centering
	{\\huge\\bfseries CLIPS\\par}
	Communication \\& Localization with Indoor Positioning Systems \\\\*
	\\line(1,0){350} \\\\
	{\\scshape\\LARGE Università di Padova \\par}
	\\vspace{1cm}
	%devono essere cambiato il titolo ogni volta
	{\\scshape\\Large Glossario v4.00\\par}
	\\logo
	\\newpage
		\\begin{tabular}{c|c}
			{\\hfill \\textbf{Versione}} 			& 4.00				\\\\[1ex]
			{\\hfill\\textbf{Data Redazione}} 		& 2015-04-05  			\\\\[1ex]
			{\\hfill\\textbf{Redazione}} 			& Davide Castello      		\\\\[1ex]
			{\\hfill\\textbf{Verifica}} 			& Marco Zanella			\\\\[1ex]
			{\\hfill\\textbf{Approvazione}} 		& Oscar Elia Conti		\\\\[1ex] 
			{\\hfill\\textbf{Uso}} 				& Esterno			\\\\[1ex]
			{\\hfill\\textbf{Distribuzione}} 		& Prof. Vardanega Tullio	\\\\[1ex]
                                                    			& Prof. Cardin Riccardo		\\\\[1ex]
                                                    			& Prof. Miriade S.p.A.		\\\\[1ex]
		\\end{tabular}
	\\end{titlepage}
	\\subfile{DiarioModificheG}

	
	\\pagestyle{mymain}
	\\glsaddall
	\\printglossary[style=myaltlistgroup, nonumberlist]

\\label{LastPage}
\\end{document}";

$file = "Glossario.tex";
open(OUT, ">$file");                            #apertura file 
print OUT $newfile;                       #serializzazione + salvataggio
close(OUT);
