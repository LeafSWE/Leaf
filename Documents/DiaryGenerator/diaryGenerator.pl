#!usr/bin/perl
# use module
use strict;
use XML::LibXML;
use POSIX qw(ceil);

my $fileLatex = @ARGV[0]; #Diario in latex
my $fileDbPath= @ARGV[1]; #Database in XML per le modifiche
my $author = @ARGV[2]; #Autore del messaggio
my $role = @ARGV[3]; #Ruolo all'interno del progetto
my $message = @ARGV[4]; #Messaggio da inserire nel diario
my $date = @ARGV[5]; #Data del messaggio
my $newVersion = @ARGV[6]; #Contiene 1 se è stata aumentata di una unità la versione da inserire, 0 altrimenti
#Calcolo la nuova versione
my $parser=XML::LibXML->new();
my $doc=$parser->parse_file($fileDbPath) || die("file non trovato \n");
my $root=$doc->getDocumentElement;
my @modifiche = $root->findnodes("/registry/entry");

my $arraySize = @modifiche;

my $version = 0.00;
my $lastVersion = 0.00;
for(my $i = 0; $i < $arraySize; $i++) {
	$lastVersion = $modifiche[$i]->getElementsByTagName("version");
	$lastVersion = "$lastVersion";
	if ($lastVersion > $version) {
		$version = $lastVersion;
	}
	$lastVersion = "";
}

if ($newVersion == 0) {
	$version = $version + 0.01;
}
else {
	#Prendo l'intero superiore
	my $versionBefore = $version;
	$version = ceil($version);
	if ($version == $versionBefore) {
		$version = $version + 1;
	}
}

#Genero il ruolo
if($role eq "amm"){
	$role = "Amministratore";
}
elsif($role eq "rp"){
	$role = "Responsabile di progetto";
}
elsif($role eq "ver"){
	$role = "Verificatore";
}
elsif($role eq "pr"){
	$role = "Progettista";
}
elsif($role eq "anal"){
	$role = "Analista";
}
elsif($role eq "cod"){
	$role = "Codificatore";
}

$message = enc($message);

#Genero il nuovo nodo da inserire
my $newEntry = "
<entry><version>$version</version><author>$author</author><role>$role</role><message>$message</message><date>$date</date></entry>
";

#Inserisco nel diario in XML la nuova modifica
my $parser=XML::LibXML->new();
my $doc=$parser->parse_file($fileDbPath) || die("file non trovato \n");
my $root=$doc->getDocumentElement;
my $newNodo=$parser->parse_balanced_chunk($newEntry) || die("something goes wrong");
my $node=$doc->findnodes("/registry")->get_node(0) || die("error:".$!);
$node->appendChild($newNodo) || die;

open(my $file, ">", "$fileDbPath") || die $$fileDbPath."->".$!;
print $file $doc->toString;
close($file);

#Genero il nuovo diario in Tex
open(my $fileLatex, '>', $fileLatex) or die "Could not open file '$fileLatex' $!";
print $fileLatex "
\\newcolumntype{V}{>{\\hsize=.40\\hsize}X[cm]}
	\\section*{Diario delle modifiche}
\\begin{longtabu} to \\textwidth {V X[c m 0.8cm] X[c m 0.7cm] X[c m 0.8cm] X[cm]}
	\\toprule
	\\textbf{Versione} & \\textbf{Data}  & \\textbf{Autore} & \\textbf{Ruolo} & \\textbf{Descrizione}\\\\
	\\midrule
	\\endhead
	\\arrayrulecolor{gray}\n
";


my $parser=XML::LibXML->new();
my $doc=$parser->parse_file($fileDbPath) || die("file non trovato \n");
my $root=$doc->getDocumentElement;
my @modifiche = $root->findnodes("/registry/entry");

my $arraySize = @modifiche;

for(my $i = $arraySize-1; $i >= 0; $i--) {
	my $version = $modifiche[$i]->getElementsByTagName("version");
	my $author = $modifiche[$i]->getElementsByTagName("author");
	my $role = $modifiche[$i]->getElementsByTagName("role");
	my $message = $modifiche[$i]->getElementsByTagName("message");
	my $data = $modifiche[$i]->getElementsByTagName("date");

	$version = enc($version);
	$author = enc($author);
	$role = enc($role);
	$message = enc($message);
	$data = enc($data);

	print $fileLatex "$version & $data & $author & $role & $message \\\\ \n";
	if ($i != 0) {
		print $fileLatex "\\midrule\n";
	}
}

print $fileLatex "
\\arrayrulecolor{black}
	\\bottomrule
\\end{longtabu}
";

close $fileLatex;

# Da USARE dopo aver prelevato il text di un nodo
sub enc {
   return Encode::encode('UTF-8', $_[0]);
}
