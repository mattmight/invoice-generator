EXE=generate-invoice
BINDIR=$$HOME/bin/


.PHONY: install
install:
	cp -v generate-invoice.awk $(BINDIR)/$(EXE)
	chmod u+rx $(BINDIR)/$(EXE)

clean:
	rm -vf *~

