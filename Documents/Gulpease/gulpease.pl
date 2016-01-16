use strict;
use warnings;

my $f = $ARGV[0];
open(FILE, "$f") or die "Could not open file: $!";
my ($phrases, $words, $letters) = (0,0,0);

my $numberOfPoints = 0;
my $numberOfLetters = 0;

for my $x (<FILE>) {
    $numberOfPoints = 0;
    $numberOfLetters = 0;
    
    $numberOfPoints = () = $x =~ /\.(?![0-9])/gi;
    $phrases += $numberOfPoints;
    $numberOfPoints = () = $x =~ /\?/gi;
    $phrases += $numberOfPoints;
    $numberOfPoints = () = $x =~ /\!/gi;
    $phrases += $numberOfPoints;
    
    $numberOfLetters = () = $x =~ /[A-z]/gi;
    $letters += $numberOfLetters;

    $words += scalar(split(/\s+/, $x));
}

print(" phrases=$phrases\n words=$words\n letters=$letters\n");
printf "l'indice gulpease calcolate è: %.2f",(89+((300*$phrases-10*$letters)/$words));
print "\n";
close("$f");