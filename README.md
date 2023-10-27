# Generate random PDF/As

A quick and dirty Bash script to generate random PDF files that declare
themselves as PDF/A.

Please note that the files do not currently validate as PDF/A;
for that, support for PDF/A_def.ps should be added first. See
[this question in Stack Overflow](https://stackoverflow.com/questions/1659147/how-to-use-ghostscript-to-convert-pdf-to-pdf-a-or-pdf-x).

Requires:
* Linux (or WSL)
* Bash
* pwgen (for producing some random content)
* vim (for writing PostScript)
* GhostScript (for writing the PDF)

Likely easily portable to macOS, if you replace pwgen with something else.
