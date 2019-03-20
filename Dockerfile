FROM rocker/tidyverse

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libgsl2 \
    libgsl-dev \
    && install2.r --error \
    rio quanteda rtweet topicmodels stm \
    && chown rstudio.rstudio /home/rstudio .
    
    
	