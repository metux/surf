# surf version
VERSION = 2.0

# Customize below to fit your system

# build tools
CC         ?= cc
PKG_CONFIG ?= pkg-config

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man
LIBPREFIX = ${PREFIX}/lib/surf

WEBKIT2GTK_VERSION ?= 4.0
GTK_VERSION        ?= 3.0
GTHREAD_VERSION    ?= 2.0

IMPORT_PACKAGES ?= \
    x11 \
    gtk+-$(GTK_VERSION) \
    webkit2gtk-$(WEBKIT2GTK_VERSION) \
    gthread-$(GTHREAD_VERSION)

IMPORT_CFLAGS ?= `$(PKG_CONFIG) --cflags $(IMPORT_PACKAGES)`
IMPORT_LIBS   ?= `$(PKG_CONFIG) --libs $(IMPORT_PACKAGES)`

# includes and libs
INCS = -I. $(IMPORT_CFLAGS)
LIBS = -lc $(IMPORT_LIBS)

# flags
CPPFLAGS = -DVERSION=\"${VERSION}\" -DWEBEXTDIR=\"${LIBPREFIX}\" -D_DEFAULT_SOURCE
CFLAGS = -std=c99 -pedantic -Wall -Os ${INCS} ${CPPFLAGS}
LDFLAGS = -s ${LIBS}

# Solaris
#CFLAGS = -fast ${INCS} -DVERSION=\"${VERSION}\"
#LDFLAGS = ${LIBS}
