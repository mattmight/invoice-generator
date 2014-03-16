generate-invoice
================

`generate-invoice` generates a LaTeX-formatted invoice from a
specially formatted TSV file.

At the moment, it is tailored to hourly consulting work billed by the
minute.

An example Excel file and [example Google spreadsheet] for tracking
hours is available as well.  TSV files generated from this
spreadsheet are compatible with the tool 

Usage
-----

If `YYYY-MM.tsv` is the input file, then run:

    $ generate-invoice < YYYY-MM.tsv > YYYY-MM.tex
    $ pdflatex YYYY-MM.tex  # generates YYYY-MM.pdf

Examples inputs are in the `example/` subdirectory.


Installation
------------

Run:

    $ make install

to install `generate-invoice` in `$HOME/bin`.


[example Google spreadsheet]: https://docs.google.com/spreadsheet/ccc?key=0AoEIaC_fw2i1dE9LbHhUSFk2MFpFQUhjR2tfUGtvbHc&usp=sharing

