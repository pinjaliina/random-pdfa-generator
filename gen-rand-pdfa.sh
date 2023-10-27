#!/bin/bash
# 
# pinja-liina.jalkanen@syke.fi @2023-10-27
#
# Create single-page PDFs with random content that declare themselves as PDF/A.
#
# Note that they aren't really PDF/A, unless a proper PDF/A definition file
# is used; see https://stackoverflow.com/questions/1659147/\
# how-to-use-ghostscript-to-convert-pdf-to-pdf-a-or-pdf-x for details.
# 
# Requires: pwgen, vim, ghostsript
#
if [[ -z $1 || $1 == '-h' || $1 == '--help' || $1 == '-?' ]]; then
	echo "Create a PDF/A file with random contents."
	echo "Usage: $0 <filename.pdf>"
	exit 1
fi
	
my_pdf=$1
my_ps=$(mktemp /tmp/$(basename $0 .sh).XXXXXX)
my_random=$(pwgen -n -C -s -B 20 |vim - -e "+hardcopy > $my_ps" "+q!")
if ! gs \
		-q \
		-dPDFA \
		-dBATCH \
		-dNOPAUSE \
		-sColorConversionStrategy=UseDeviceIndependentColor \
		-sDEVICE=pdfwrite \
		-dPDFACompatibilityPolicy=2 \
		-sOutputFile=$my_pdf $my_ps; then
	echo "Failed to create the PDF!"
	exit 1
fi
if rm $my_ps; then
	exit 0
else
	exit 1
fi
