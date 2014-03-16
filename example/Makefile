GI=generate-invoice
NAME=example

$(NAME).pdf: $(NAME).tex
	pdflatex $(NAME)

$(NAME).tex: $(NAME).tsv
	$(GI) < $(NAME).tsv > $(NAME).tex

# Uncomment if the tsv comes from csv:
# $(NAME).tsv: $(NAME).csv
#	# See https://github.com/mattmight/csv2tsv if you need csv2tsv
#	csv2tsv < $(NAME).csv > $(NAME).tsv

clean:
	rm -f $(NAME).{aux,log,pdf,tex}
