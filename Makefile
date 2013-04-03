PREFIX?=/usr/local
BIN=${PREFIX}/bin
MD_FILE=md2html.awk
SS=${BIN}/ss

all: install

install:
	mkdir -p ${BIN}
	sed -e "s,/usr/bin/awk,`which awk`,g" ${MD_FILE} > ${BIN}/${MD_FILE}
	chmod +x ${BIN}/${MD_FILE}
	cp -f ss ${SS}
	chmod +x ${SS}
	## You're good to go! ##
