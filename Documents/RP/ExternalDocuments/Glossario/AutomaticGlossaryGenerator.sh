#!/bin/bash
perl glossario.pl
pdflatex Glossario.tex
makeglossaries Glossario
pdflatex Glossario
pdflatex Glossario
rm Glossario.aux
rm Glossario.glo
rm Glossario.glg
rm Glossario.gls
rm Glossario.ist
rm Glossario.log
rm Glossario.out
