FROM debian:jessie
MAINTAINER Daniel Mendler <mail@daniel-mendler.de>

RUN apt-get update && \
                       # gcc, make, etc.
    apt-get install -y build-essential 		       \
		       python3 python3-dev python3-pip \
		       ruby ruby-dev		       \
		       libzmq3 libzmq3-dev 	       \
		       gnuplot-nox		       \
		       # used by rbczmq
		       libtool autoconf automake       \
		       # used by gsl-nmatrix
		       libgsl0-dev		       \
                       # used by nokogiri/publisci, see http://www.nokogiri.org/tutorials/installing_nokogiri.html
                       zlib1g-dev                      \
		       # used by nmatrix
		       libatlas-base-dev	    && \
    apt-get clean && \
    ln -s /usr/bin/libtoolize /usr/bin/libtool # See https://github.com/zeromq/libzmq/issues/1385

RUN pip3 install "ipython[notebook]"

RUN gem install --no-rdoc --no-ri iruby pry						\
				  nmatrix gsl-nmatrix					\
				  rubyvis nyaplot plotrb gnuplot			\
				  awesome_print						\
				  minimization integration distribution			\
				  statsample statsample-glm				\
				  statsample-timeseries statsample-bivariate-extension 	\
				  extendmatrix						\
                                  publisci                                              \
                                  ai4r                                                  \
			          daru						     && \
    iruby register

ADD . /notebooks
WORKDIR /notebooks

EXPOSE 8888

# Convert notebooks to the current format
RUN find . -name '*.ipynb' -exec ipython nbconvert --to notebook {} --output {} \;
RUN find . -name '*.ipynb' -exec ipython trust {} \;

CMD ipython notebook
