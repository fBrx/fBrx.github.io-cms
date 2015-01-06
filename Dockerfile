FROM ubuntu:14.04
MAINTAINER Florian Brüssel <florian@florian-m.net>

#install utilities
RUN apt-get update && apt-get install -y wget curl mc

#download and extract hugo
RUN wget -O /opt/hugo.tar.gz https://github.com/spf13/hugo/releases/download/v0.12/hugo_0.12_linux_amd64.tar.gz
RUN tar -xzvf /opt/hugo.tar.gz -C /opt/

#create link to hugo in /usr/local/bin
RUN ln -s /opt/hugo_0.12_linux_amd64/hugo_0.12_linux_amd64 /usr/local/bin/hugo

#expose default hugo server port
EXPOSE 1313

#set startup command
ENTRYPOINT ["hugo"]
