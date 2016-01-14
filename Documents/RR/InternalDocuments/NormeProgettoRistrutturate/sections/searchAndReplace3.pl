#!/usr/bin/perl -w

use strict;
use warnings;

print "inizio\n";
my $glos = "glos.txt";
my $g = read_file($glos);
my @glossario = split($g, "\n");
print @glossario;
my $filename = $ARGV[0];

my $data = read_file($filename);
foreach my $word (@glossario){
	$data =~ s/^$word$/\\gls{$word}\\g/g;
}	
write_file($filename, $data);
exit;
 
sub read_file {
    my ($filename) = @_;
 
    open my $in, '<:encoding(UTF-8)', $filename or die "Could not open '$filename' for reading $!";
    local $/ = undef;
    my $all = <$in>;
    close $in;
 	print $all."ciao\n";
    return $all;
}
 
sub write_file {
    my ($filename, $content) = @_;
 
    open my $out, '>:encoding(UTF-8)', $filename or die "Could not open '$filename' for writing $!";;
    print $out $content;
    close $out;
 
    return;
}
     
