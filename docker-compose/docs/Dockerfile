FROM ubuntu:24.04

# install nodejs
RUN apt-get update
RUN apt-get install -y ca-certificates curl gnupg
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update
RUN apt-get install nodejs -y

# install pandoc
RUN apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    pandoc \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*

# install latex
RUN apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    texlive-latex-recommended \
    texlive-fonts-recommended \
    lmodern \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*


# install python
RUN apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-full \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*

# install python dependencies
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt --break-system-packages && rm requirements.txt

# install chromium
RUN apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    wget \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    ./google-chrome-stable_current_amd64.deb \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*

# install mermaid-cli
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable
RUN npm install -g @mermaid-js/mermaid-cli

# install sudo
RUN apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    sudo \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*

# Add group & user + sudo
RUN groupadd -r user && useradd --create-home --gid user user && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user
ENV HOME /home/user