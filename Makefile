PREFIX?=/usr/local
BIN=${PREFIX}/bin
MD=${BIN}/md2html.awk
SS=${BIN}/ss

all: install

install:
	mkdir -p ${BIN}
	sed -e "s,/usr/bin/awk,`which awk`,g" md2html.awk > ${MD}
	chmod +x ${MD}
	cp -f ss ${SS}
	chmod +x ${SS}
