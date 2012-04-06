DESTDIR?=
PREFIX?=/usr/local
P=${DESTDIR}/${PREFIX}

all: ss.conf

ss.conf:
	cp ss.conf.def ss.conf

install:
	mkdir -p ${P}/bin
	sed -e "s,/usr/bin/awk,`./whereis awk`,g" md2html.awk > ${P}/bin/md2html.awk
	chmod +x ${P}/bin/md2html.awk
	cp -f ss ${P}/bin/ss
	chmod +x ${P}/bin/ss
