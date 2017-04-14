# surf - simple browser
# See LICENSE file for copyright and license details.

include config.mk

SRC = surf.c
OBJ = ${SRC:.c=.o}

all: check-libs options surf

check-libs:
	@if ! $(PKG_CONFIG) --exists $(IMPORT_PACKAGES) ; then \
            echo "failed importing via pkg-config: $(IMPORT_PACKAGES)" >&2 ; \
            exit 42; \
        fi

options:
	@echo surf build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

surf: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ surf.o ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f surf ${OBJ} surf-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p surf-${VERSION}
	@cp -R LICENSE Makefile config.mk config.def.h README \
		surf-open.sh arg.h TODO.md surf.png \
		surf.1 ${SRC} surf-${VERSION}
	@tar -cf surf-${VERSION}.tar surf-${VERSION}
	@gzip surf-${VERSION}.tar
	@rm -rf surf-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${BINDIR}
	@mkdir -p ${DESTDIR}${BINDIR}
	@cp -f surf ${DESTDIR}${BINDIR}
	@chmod 755 ${DESTDIR}${BINDIR}/surf
	@echo installing manual page to ${DESTDIR}${MAN1DIR}
	@mkdir -p ${DESTDIR}${MAN1DIR}
	@sed "s/VERSION/${VERSION}/g" < surf.1 > ${DESTDIR}${MAN1DIR}/surf.1
	@chmod 644 ${DESTDIR}${MAN1DIR}/surf.1

uninstall:
	@echo removing executable file from ${DESTDIR}${BINDIR}
	@rm -f ${DESTDIR}${BINDIR}/surf
	@echo removing manual page from ${DESTDIR}${MAN1DIR}
	@rm -f ${DESTDIR}${MAN1DIR}/surf.1

.PHONY: all options clean dist install uninstall
