# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/oniguruma/oniguruma-4.7.0.ebuild,v 1.1 2007/08/11 16:48:18 matsuu Exp $

EAPI="prefix"

MY_P="onig-${PV}"

DESCRIPTION="Regular expression library"
HOMEPAGE="http://www.geocities.jp/kosako3/oniguruma/"
SRC_URI="http://www.geocities.jp/kosako3/oniguruma/archive/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc-macos ~x86 ~x86-macos ~x86-solaris"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS HISTORY README* doc/*
}
