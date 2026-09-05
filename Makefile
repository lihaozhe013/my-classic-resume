.PHONY: all compile clean format

default: compile

clean:
	rm -f $(TARGET_FILE).aux \
		$(TARGET_FILE).log \
		$(TARGET_FILE).out \
		$(TARGET_FILE).toc \
		$(TARGET_FILE).nav \
		$(TARGET_FILE).snm \
		$(TARGET_FILE).dvi \
		$(TARGET_FILE).ps \
		$(TARGET_FILE).bbl \
		$(TARGET_FILE).blg \
		$(TARGET_FILE).fls \
		$(TARGET_FILE).fdb_latexmk \
		$(TARGET_FILE).gz \
		$(TARGET_FILE).idx \
		$(TARGET_FILE).ilg \
		$(TARGET_FILE).ind
	rm -f $(TARGET_FILE).pdf
	find . -regextype posix-extended -regex '.*\.'$(TEMP_FILES_SUFFIX)'$$' -delete
	@echo "Cleanup finished."

format:
	uv run format.py

compile:
	pdflatex resume.tex

all:
	pdflatex resume.tex && pdflatex resume.tex && pdflatex resume.tex
