#!/bin/bash
# Script per cancellare file generati dalla compilazione in latex
find . -name "*.gz" -type f -delete
find . -name "*.dvi" -type f -delete
find . -name "*.log" -type f -delete
find . -name "*.sta" -type f -delete
