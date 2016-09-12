# TODO vendor all these dependencies
FROM golang:alpine
RUN \
  apk update && apk add git make build-base openssl curl file autoconf automake libtool linux-headers libssh2-dev && \
  cd /root && \
  git clone https://github.com/sandstorm-io/capnproto.git && \
  cd capnproto && \
  cd c++ && \
  autoreconf -i && \
  ./configure && \
  make -j6 check && \
  make install && \
  cd .. && \
  go get -u -t github.com/glycerine/go-capnproto && \
  cd $GOPATH/src/github.com/glycerine/go-capnproto && \
  make && \
  go test -v && \
  go get -u -t -d github.com/glycerine/bambam && \
  cd $GOPATH/src/github.com/glycerine/bambam && \
  make && \
  go install && \
  cd /root && \
  git clone http://luajit.org/git/luajit-2.0.git && \
  cd luajit-2.0 && \
  git checkout v2.1 && \
  make && \
  make install && \
  ln -sf luajit-2.1.0-beta2 /usr/local/bin/luajit && \
  ln -sf luajit /usr/local/bin/lua && \
  cd /root && \
  curl -sSL https://github.com/keplerproject/luarocks/archive/v2.3.0.tar.gz | gunzip | tar xf - && \
  cd luarocks-2.3.0 && \
  ./configure --lua-suffix=jit-2.1.0-beta2 --with-lua=/usr/local --with-lua-include=/usr/local/include/luajit-2.1 && \
  make && \
  make install && \
  luarocks install lua-capnproto && \
  cd /root && \
  curl -sSL http://www.kyne.com.au/~mark/software/download/lua-cjson-2.1.0.tar.gz | gunzip | tar xf - && \
  cd lua-cjson-2.1.0 && luarocks make && \
  cd / && git clone https://github.com/justincormack/ljsyscall.git && \
  mkdir -p /usr/local/share/lua/5.1 && cp -a ljsyscall/syscall.lua ljsyscall/syscall /usr/local/share/lua/5.1/ && \
  rm -rf /root/*
