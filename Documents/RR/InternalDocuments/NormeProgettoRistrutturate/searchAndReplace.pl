#!/usr/bin/perl -w

use strict;


my @glossario=("Astah",
"Template Latex",
"Latex",
"Google",
"Google drive",
"Git",
"GitHub",
"Repository",
"Ticket",
"Diagramma di Gantt",
"Monospace",
"PNG",
"Android",
"Java",
"PDF",
"Team",
"CamelCase",
"Beacon",
"Mailing list",
"Telegram",
"Skype",
"Teamwork",
"UML",
"Bluetooth",
"Unicode",
"BOM",
"Markup, Linguaggio di markup",
"PERT",
"WBS",
"GanttProject",
"To-do list");

my $file = $ARGV[0];
open(FILE, "<$file") || die "File not found";
my @lines = <FILE>;
close(FILE);
my $i=0;
my @newlines;
	foreach(@lines) {
		foreach my $word (@glossario){
			$_ =~ s/$word[^}\\g]/\\gls{$word}\\g/g;
		}
		push(@newlines,$_);
	}

open(FILE, ">$file") || die "File not found";
print FILE @newlines;
close(FILE);

