export SHELL=/bin/bash

files: oneside_english oneside_greek printable_english printable_greek

default: oneside_english

oneside_english: Thesis_oneside_english.tex
	cp Thesis_oneside_english.tex Thesis.tex
	pdflatex Thesis.tex
	biber Thesis
	pdflatex Thesis.tex
	pdflatex Thesis.tex

oneside_greek: Thesis_oneside_greek.tex
	cp Thesis_oneside_greek.tex Thesis.tex
	pdflatex Thesis.tex
	biber Thesis
	pdflatex Thesis.tex
	pdflatex Thesis.tex

printable_english: Thesis_printable_english.tex
	cp Thesis_printable_english.tex Thesis.tex
	pdflatex Thesis.tex
	biber Thesis
	pdflatex Thesis.tex
	pdflatex Thesis.tex

printable_greek: Thesis_printable_greek.tex
	cp Thesis_printable_greek.tex Thesis.tex
	pdflatex Thesis.tex
	biber Thesis
	pdflatex Thesis.tex
	pdflatex Thesis.tex
clean:
	$(RM) *.{xml,bcf,dvi,aux,log,toc,lof,lol,lot,dlog,bbl,blg,idx,out,tpt,svn,backup}
	$(RM) FrontMatter/*.{xml,bcf,dvi,aux,log,toc,lof,lol,lot,dlog,bbl,blg,idx,out,tpt,svn,backup}
	$(RM) MainMatter/*.{xml,bcf,dvi,aux,log,toc,lof,lol,lot,dlog,bbl,blg,idx,out,tpt,svn,backup}
	rm Thesis.tex
