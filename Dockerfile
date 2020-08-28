FROM texlive/texlive:latest
RUN apt-get update && apt-get install -y \
    wget \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    && rm -rf /var/lib/apt/lists/*

RUN ARCH=$(dpkg --print-architecture) && \
    wget "https://github.com/jgm/pandoc/releases/download/3.9/pandoc-3.9-1-${ARCH}.deb" && \
    dpkg -i "pandoc-3.9-1-${ARCH}.deb" && \
    rm "pandoc-3.9-1-${ARCH}.deb"

RUN pandoc --version
WORKDIR /workspace
ENTRYPOINT ["/bin/bash", "-c"]