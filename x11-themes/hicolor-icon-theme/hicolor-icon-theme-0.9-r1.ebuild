# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/hicolor-icon-theme/hicolor-icon-theme-0.9-r1.ebuild,v 1.15 2007/02/15 22:58:46 dang Exp $

EAPI="prefix"

# The gnome2 eclass must be inherited to update the icon cache.  All exported
# functions should be overridden

inherit eutils gnome2-utils

DESCRIPTION="Fallback theme for the freedesktop icon theme specification"
HOMEPAGE="http://icon-theme.freedesktop.org/wiki/HicolorTheme"
SRC_URI="http://icon-theme.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc-macos ~x86 ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND=""
RESTRICT="binchecks strip"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Add the dropped stock icons
	epatch "${FILESDIR}"/${PN}-0.9-stock-document-icons.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc ChangeLog README
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
