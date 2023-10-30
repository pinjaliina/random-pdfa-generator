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
	echo "Usage:"
	echo -e "\t$0 <filename.pdf>"
	echo -e "\t\t-- OR --"
	echo -e "\t$0 -u, --name-output-by-uuidv4"
	exit 1
fi
my_pdffn=$1
my_uuidv4=$(uuid -v 4)
if [[ $1 == '-u' || $1 == '--name-output-by-uuidv4' ]]; then
	my_pdffn="$(pwd)/$my_uuidv4.pdf"
fi
my_psfn=$(mktemp /tmp/$(basename $0 .sh).XXXXXX)
my_random=$(pwgen -n -C -s -B 20)
my_sha256=$(echo -n $mystring |sha256sum |cut -f 1 -d' ')
my_string=$(echo -e "$my_random\n\nSHA-256: $my_sha256\nUUID v4: $my_uuidv4")
if ! (echo "$my_string"| vim - -e "+hardcopy > $my_psfn" "+q!"); then
	exit 1
fi
if ! gs \
		-q \
		-dPDFA \
		-dBATCH \
		-dNOPAUSE \
		-sColorConversionStrategy=UseDeviceIndependentColor \
		-sDEVICE=pdfwrite \
		-dPDFACompatibilityPolicy=2 \
		-sOutputFile=$my_pdffn $my_psfn; then
	echo "Failed to create the PDF!"
	exit 1
fi
if rm $my_psfn; then
	exit 0
else
	exit 1
fi
