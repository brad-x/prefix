# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pida/pida-0.5.1.ebuild,v 1.5 2008/11/26 11:42:24 welp Exp $

EAPI="prefix"

NEED_PYTHON=2.4

inherit distutils eutils
MY_P="PIDA-${PV}"

DESCRIPTION="Gtk and/or Vim-based Python Integrated Development Application"
HOMEPAGE="http://pida.co.uk/"
SRC_URI="http://pida.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86-interix ~amd64-linux ~x86-linux"
IUSE="gnome"

RDEPEND=">=dev-python/pygtk-2.8
	dev-python/gnome-python
	gnome? ( >=dev-python/gnome-python-extras-2.14.0-r1 )
	>=x11-libs/vte-0.11.11-r2
	>=dev-python/kiwi-1.9.1
	>=app-editors/gvim-6.3
	>=gnome-base/librsvg-2.22.2"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-0.6_rc8-r1
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if ! built_with_use x11-libs/vte python ; then
		eerror "x11-libs/vte has to be built with python USE-flag"
		die "missing python USE-flag for x11-libs/vte"
	fi
}

src_install() {
	distutils_src_install

	make_desktop_entry pida Pida \
		/usr/lib/python2.5/site-packages/pida/resources/pixmaps/pida-icon.png \
		Development
}

pkg_postinst() {
	elog "Optional packages pida integrates with:"
	elog "app-misc/mc (Midnight Commander)"
	elog "dev-util/gazpacho (Glade-like interface designer)"
	elog "Revision control: cvs, svn, darcs and many others"
}
