FROM rocker/rstudio

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libgsl2 \
    && install2.r --error \
    tidyverse rio quanteda rtweet topicmodels stm
    
	