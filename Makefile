# ===============================================
# Docker Compose-based LaTeX Workflow
# Author: Haozhe Li
# ===============================================

# ----------------- Configuration -----------------
COMPOSE = docker compose
SERVICE = latex
TARGET_FILE = resume

default: compile
# ----------------- Container Management -----------------
start:
	$(COMPOSE) up -d $(SERVICE)

stop:
	$(COMPOSE) stop

remove:
	$(COMPOSE) down

# ----------------- Compilation Tasks -----------------
compile:
	$(COMPOSE) exec $(SERVICE) pdflatex $(TARGET_FILE).tex

all:
	@echo "--- Compiling $(TARGET_FILE).tex using pdflatex ---"
	# First compilation (generating .aux, .toc, and other files)
	$(COMPOSE) exec $(SERVICE) pdflatex $(TARGET_FILE).tex
	# (If using Biber or BibTeX, insert the corresponding exec command here)
	# $(COMPOSE) exec $(SERVICE) biber $(TARGET_FILE)
	# Second Compilation (Handling References and Directories)
	$(COMPOSE) exec $(SERVICE) pdflatex $(TARGET_FILE).tex
	# Third compilation (ensuring all cross-references are correct; if using BibTeX, also requires)
	$(COMPOSE) exec $(SERVICE) pdflatex $(TARGET_FILE).tex
	@echo "--- Compilation complete: $(TARGET_FILE).pdf generated ---"

xelatex:
	@echo "--- 3. Compiling $(TARGET_FILE).tex using xelatex ---"
	$(COMPOSE) exec $(SERVICE) xelatex $(TARGET_FILE).tex
	$(COMPOSE) exec $(SERVICE) xelatex $(TARGET_FILE).tex
	@echo "--- XeLaTeX compilation complete: $(TARGET_FILE).pdf generated ---"

# ----------------- Cleanup -----------------

clean:
	@echo "--- 4. Cleaning up intermediate files ---"
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
	@echo "Cleanup finished."

quick: start compile stop

# ----------------- Formatting -----------------
format:
	@echo "--- 5. Formatting all .tex files with latexindent ---"
	@echo "Note: This runs inside compose service $(SERVICE) as host user."
	$(COMPOSE) exec -u "$(shell id -u):$(shell id -g)" $(SERVICE) sh -lc '\
		set -e; \
		cd /workdir; \
		echo "Finding and formatting all .tex files..."; \
		find . -type f -name "*.tex" -exec latexindent -n -w -b=0 {} +; \
		echo "All .tex files formatted." \
	'

.PHONY: all compile clean start stop quick xelatex format