FROM ubuntu:24.04
WORKDIR /hugo

# Install the application dependencies
ENV HUGO_VERSION=0.128.0

RUN apt-get update 
RUN apt-get install -y wget
RUN wget -O hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb
RUN wget -O sass.tar.gz https://github.com/sass/dart-sass/releases/download/1.89.2/dart-sass-1.89.2-linux-x64.tar.gz
RUN tar xzf sass.tar.gz
RUN cd /usr/bin && ln -s /hugo/dart-sass/sass
RUN dpkg -i hugo.deb

CMD [ "/mnt/produce.sh", "inside" ]
