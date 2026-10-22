FROM scorpiobroker/all-in-one-runner:java-5.0.7 AS builder

# install curl
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    libcurl4 \
    libkrb5-3 \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*
