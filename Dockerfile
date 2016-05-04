FROM debian:jessie
MAINTAINER Daniel Mendler <mail@daniel-mendler.de>

RUN apt-get update && \
                       # gcc, make, etc.
    apt-get install -y --no-install-recommends \
        build-essential                        \
        python3 python3-dev python3-pip        \
        ruby ruby-dev                          \
        libzmq3 libzmq3-dev                    \
        gnuplot-nox                            \
        libgsl0-dev                            \
        # used by rbczmq
        libtool autoconf automake              \
        # used by nokogiri/publisci, see http://www.nokogiri.org/tutorials/installing_nokogiri.html
        zlib1g-dev                             \
        # used by stuff-classifier
        libsqlite3-dev                         \
        # used by rmagick
        libmagick++-dev imagemagick            \
        # used by nmatrix
        libatlas-base-dev             &&       \
    apt-get clean && \
    ln -s /usr/bin/libtoolize /usr/bin/libtool # See https://github.com/zeromq/libzmq/issues/1385

RUN pip3 install "ipython[notebook]"

RUN gem update --no-document --system && \
    gem install --no-document sciruby-full && \
    iruby register

ADD . /notebooks
WORKDIR /notebooks

EXPOSE 8888

# Convert notebooks to the current format
RUN find . -name '*.ipynb' -exec ipython nbconvert --to notebook {} --output {} \;
RUN find . -name '*.ipynb' -exec ipython trust {} \;

CMD ipython notebook
