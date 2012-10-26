# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gst-plugins-good/gst-plugins-good-0.10.31.ebuild,v 1.1 2012/10/23 07:55:22 tetromino Exp $

EAPI=4

# order is important, gnome2 after gst-plugins
inherit gst-plugins-good gst-plugins10 gnome2 eutils flag-o-matic libtool

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
KEYWORDS="~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="+orc"

RDEPEND=">=media-libs/gst-plugins-base-0.10.36
	>=media-libs/gstreamer-0.10.36
	orc? ( >=dev-lang/orc-0.4.11 )
	>=dev-libs/glib-2.24:2
	sys-libs/zlib
	app-arch/bzip2"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=sys-devel/gettext-0.11.5
	virtual/pkgconfig
	!<media-libs/gst-plugins-bad-0.10.22" # audioparsers and qtmux moves

# Always enable optional bz2 support for matroska
# Always enable optional zlib support for qtdemux and matroska
# Many media files require these to work, as some container headers are often compressed, bug 291154
GST_PLUGINS_BUILD="bz2 zlib"

# overrides the eclass
src_prepare() {
	[[ ${CHOST} == *-interix3* ]] && epatch "${FILESDIR}"/${PN}-0.10.8-interix3.patch

	# Required for FreeBSD sane .so versioning
	elibtoolize
}

src_configure() {
	# gst doesnt handle optimisations well
	strip-flags
	replace-flags "-O3" "-O2"
	filter-flags "-fprefetch-loop-arrays" # see bug 22249

	gst-plugins-good_src_configure \
		$(use_enable orc) \
		--disable-examples \
		--with-default-audiosink=autoaudiosink \
		--with-default-visualizer=goom
}

# override eclass
src_install() {
	gnome2_src_install
	prune_libtool_files --modules
}

DOCS="AUTHORS ChangeLog NEWS README RELEASE"

pkg_postinst () {
	gnome2_pkg_postinst

	echo
	elog "The Gstreamer plugins setup has changed quite a bit on Gentoo,"
	elog "applications now should provide the basic plugins needed."
	echo
	elog "The new seperate plugins are all named 'gst-plugins-<plugin>'."
	elog "To get a listing of currently available plugins execute 'emerge -s gst-plugins-'."
	elog "In most cases it shouldn't be needed though to emerge extra plugins."
}

pkg_postrm() {
	gnome2_pkg_postrm
}
