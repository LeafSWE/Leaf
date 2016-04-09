#!/bin/sh

PERL=/c/Perl64/bin/perl.exe
# Allows us to read user input below, assigns stdin to keyboard
exec < /dev/tty
    AUTHOR=""
    while [ "$AUTHOR" != "at" ] && [ "$AUTHOR" != "ca" ] && [ "$AUTHOR" != "dc" ] && [ "$AUTHOR" != "eb" ] && [ "$AUTHOR" != "ft" ] && [ "$AUTHOR" != "oec" ] && [ "$AUTHOR" != "mz" ]  ; do
        exec < /dev/tty; read -p "Who are you? (at/ca/dc/eb/ft/oec/mz) " AUTHOR;
    done;
    if [ "$AUTHOR" = "at" ]; then
        AUTHOR="Andrea Tombolato"
    elif [ "$AUTHOR" = "ca" ]; then
        AUTHOR="Cristian Andrighetto"
    elif [ "$AUTHOR" = "dc" ]; then
        AUTHOR="Davide Castello"
    elif [ "$AUTHOR" = "eb" ]; then
        AUTHOR="Eduard Bicego"
    elif [ "$AUTHOR" = "ft" ]; then
        AUTHOR="Federico Tavella"
    elif [ "$AUTHOR" = "oec" ]; then
        AUTHOR="Oscar Elia Conti"
    elif [ "$AUTHOR" = "mz" ]; then
        AUTHOR="Marco Zanella"
    fi
    MESSAGE=""
    exec < /dev/tty; read -p "Write the modify message: " MESSAGE;
	DATE=`date +%Y-%m-%d` #retrieve the date of modify
    doc=""
    role=""
    currPath="$(pwd)"
    #set which document
    while [ "$doc" != "ar" ] && [ "$doc" != "gl" ] && [ "$doc" != "np" ] && [ "$doc" != "pp" ] && [ "$doc" != "pq" ] && [ "$doc" != "sf" ] && [ "$doc" != "st" ] && [ "$doc" != "dp" ] ; do
        exec < /dev/tty; read -p "Which document? (ar/gl/np/pp/pq/sf/st/dp) " doc;
    done;
    #Domando il ruolo per poterlo inserire nel diario
    while [ "$role" != "amm" ] && [ "$role" != "rp" ] && [ "$role" != "ver" ] && [ "$role" != "pr" ] && [ "$role" != "anal" ] && [ "$doc" != "cod" ] ; do
        exec < /dev/tty; read -p "Which role do you have? (amm/rp/ver/pr/anal/cod) " role;
    done;

    #Cerco il percorso dei file da modificare per le NORME
    if [ "$doc" = "np" ]; then
        doc="NP"
        docTexName="NormeProgetto.tex"
        docPDFName="NormeProgetto.pdf"
    #Cerco il percorso dei file da modificare per l'analisi
    elif [ "$doc" = "ar" ]; then
        doc="AR"
        docTexName="AnalisiDeiRequisiti.tex"
        docPDFName="AnalisiDeiRequisiti.pdf"
    #Cerco il percorso dei file da modificare per il glossario
    elif [ "$doc" = "gl" ]; then
        doc="GLO"
        docTexName="Glossario.tex"
        docPDFName="Glossario.pdf"
    elif [ "$doc" = "pp" ]; then
        doc="PP"
        docTexName="PianoProgetto.tex"
        docPDFName="PianoProgetto.pdf"
    elif [ "$doc" = "pq" ]; then
        doc="PQ"
        docTexName="PianoDiQualifica.tex"
        docPDFName="PianoDiQualifica.pdf"
    elif [ "$doc" = "sf" ]; then
        doc="SF"
        docTexName="StudioDiFattibilita.tex"
        docPDFName="StudioDiFattibilita.pdf"
    elif [ "$doc" = "st" ]; then
        doc="ST"
        docTexName="SpecificaTecnica.tex"
        docPDFName="SpecificaTecnica.pdf"
    elif [ "$doc" = "dp" ]; then
        doc="DP"
        docTexName="DefinizioneDiProdotto.tex"
        docPDFName="DefinizioneDiProdotto.pdf"
    fi

    diaryTexPath=$(find . -name "diarioModifiche$doc.tex") #Perocorso del diario in latex
    docTexPath=$(find . -name "$docTexName") #Percorso del file latex da compilare
    docPDFPath=$(find . -name "$docPDFName") #Percorso norme db
    path=$(dirname "${docTexPath}") #Percorso della cartella

    #Se il file del diario non esiste lo inizializzo
    if [ ! -f "$path/registroModifiche$doc.xml" ]; then #file initialization if it doesnt exists
        echo "<registry></registry>" >> "$path/registroModifiche$doc.xml"
    fi

    version=""
    while [ "$version" != "y" ] && [ "$version" != "Y" ] && [ "$version" != "N" ] && [ "$version" != "n" ]; do
        exec < /dev/tty; read -p "Augment version? (y/N) " version;
    done; #ask if augment version->usefull for trasformation to latex

    if [ "$version" = "y" ] || [ "$version" = "Y" ]; then
        version="1"
    else
        version="0"
    fi

    #write on file
    #Generate latex diary
    echo "Updating xml diary and generating new TeX diary..";
    $PERL ./diaryGenerator.pl "$diaryTexPath" "$path/registroModifiche$doc.xml" "$AUTHOR" "$role" "$MESSAGE" "$DATE" "$version";
    echo "Generation done.";
    #Turn up and compile the new diary
    cd $path;
    echo "Compiling $docTexName..";
    pdflatex -interaction=nonstopmode $docTexName > /dev/null;
    pdflatex -interaction=nonstopmode $docTexName > /dev/null;
    echo "Compilation done.";
    echo "Deleting temp files from compilation..";
    find . -name "*.gz"  -type f -delete
    find . -name "*.dvi" -type f -delete
    find . -name "*.log" -type f -delete
    find . -name "*.sta" -type f -delete
    find . -name "*.aux" -type f -delete
    find . -name "*.lof" -type f -delete
    find . -name "*.toc" -type f -delete
    find . -name "*.out" -type f -delete
    find . -name "*.gz(busy)" -type f -delete
    echo "Deleted.";
    cd $currPath;
    #automatic add and commit for registry file
    git add "$path/registroModifiche$doc.xml" "$diaryTexPath" "$docPDFPath"; git commit -m "Automatic commit for diary update";
