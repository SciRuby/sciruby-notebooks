FROM debian:jessie
MAINTAINER Daniel Mendler <mail@daniel-mendler.de>

RUN apt-get update && \
    apt-get install -y build-essential 			`# gcc, make etc`			\
		       python3 python3-dev python3-pip 	`# how stupid can a shell syntax be?`	\
		       ruby ruby-dev								\
		       libzmq3 libzmq3-dev 							\
		       libtool autoconf automake 	`# used by rbczmq`			\
		       libatlas-base-dev		`# used by nmatrix`
    apt-get clean && \
    ln -s /usr/bin/libtoolize /usr/bin/libtool # See https://github.com/zeromq/libzmq/issues/1385

RUN pip3 install "ipython[notebook]"

RUN gem install --no-rdoc --no-ri iruby pry nmatrix rubyvis nyaplot && iruby register

ADD . /notebooks
WORKDIR /notebooks

EXPOSE 8888

CMD ipython notebook
