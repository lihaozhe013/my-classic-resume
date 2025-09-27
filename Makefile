# ===============================================
# Dockerized LaTeX Compilation Workflow
# Author: Haozhe Li
# ===============================================

# ----------------- Configuration -----------------
DOCKER_IMAGE = registry.gitlab.com/islandoftex/images/texlive:latest
CONTAINER_NAME = latex_compiler_session
TARGET_FILE = resume
WORKDIR_IN_CONTAINER = /workdir
LOCAL_PWD = ${PWD}

# ----------------- Container Management -----------------
start:
	@echo "--- 1. Starting Docker container: $(CONTAINER_NAME) ---"
	# Run in the background using -d (detach), mount the current directory using -v, The container will start and enter a dormant state (tail -f /dev/null), ready to receive subsequent commands
	docker run -d \
		--name $(CONTAINER_NAME) \
		-v $(LOCAL_PWD):$(WORKDIR_IN_CONTAINER) \
		-w $(WORKDIR_IN_CONTAINER) \
		$(DOCKER_IMAGE) tail -f /dev/null
	@echo "Container $(CONTAINER_NAME) is running and mounted to $(LOCAL_PWD)"

stop:
	@echo "--- 2. Stopping Docker container: $(CONTAINER_NAME) ---"
	docker stop $(CONTAINER_NAME) || true
	@echo "Container $(CONTAINER_NAME) has been stopped."
delete:
	@echo "--- 2. Removing Docker container: $(CONTAINER_NAME) ---"
	docker rm $(CONTAINER_NAME) || true
	@echo "Container $(CONTAINER_NAME) has been removed."

# ----------------- Compilation Tasks -----------------
all:
	docker exec $(CONTAINER_NAME) pdflatex $(TARGET_FILE).tex

compile:
	@echo "--- 3. Compiling $(TARGET_FILE).tex using pdflatex ---"
	# First compilation (generating .aux, .toc, and other files)
	docker exec $(CONTAINER_NAME) pdflatex $(TARGET_FILE).tex
	# (If using Biber or BibTeX, insert the corresponding exec command here)
	# docker exec $(CONTAINER_NAME) biber $(TARGET_FILE)
	# Second Compilation (Handling References and Directories)
	docker exec $(CONTAINER_NAME) pdflatex $(TARGET_FILE).tex
	# Third compilation (ensuring all cross-references are correct; if using BibTeX, also requires)
	docker exec $(CONTAINER_NAME) pdflatex $(TARGET_FILE).tex
	@echo "--- Compilation complete: $(TARGET_FILE).pdf generated ---"

xelatex:
	@echo "--- 3. Compiling $(TARGET_FILE).tex using xelatex ---"
	docker exec $(CONTAINER_NAME) xelatex $(TARGET_FILE).tex
	docker exec $(CONTAINER_NAME) xelatex $(TARGET_FILE).tex
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
	@echo "Note: This runs inside container $(CONTAINER_NAME). Ensure it's started (make start)."
	docker exec $(CONTAINER_NAME) sh -lc '\
		set -e; \
		cd $(WORKDIR_IN_CONTAINER); \
		for f in $$(find . -type f -name "*.tex"); do \
			echo "Formatting $$f"; \
			latexindent "$$f" > "$$f.__tmp__" && mv "$$f.__tmp__" "$$f"; \
		done; \
		echo "All .tex files formatted." \
	'

.PHONY: all compile clean start stop quick xelatex cleanup_and_stop format