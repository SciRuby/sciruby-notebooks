FROM debian:jessie
MAINTAINER Daniel Mendler <mail@daniel-mendler.de>

RUN apt-get update && \
    apt-get install -y build-essential python-dev ruby ruby-dev libzmq3 libzmq3-dev libtool autoconf automake && \
    apt-get clean &&
    ln -s /usr/bin/libtoolize /usr/bin/libtool # See https://github.com/zeromq/libzmq/issues/1385

RUN pip install "ipython[notebook]"

RUN gem install --no-rdoc --no-ri iruby pry nmatrix rubyvis nyaplot && iruby register

ADD . /notebooks
WORKDIR /notebooks

EXPOSE 8888

CMD ipython notebook
