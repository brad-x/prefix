# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/twolame/twolame-0.3.12.ebuild,v 1.9 2009/04/04 20:16:38 solar Exp $

inherit libtool

DESCRIPTION="TwoLAME is an optimised MPEG Audio Layer 2 (MP2) encoder"
HOMEPAGE="http://www.twolame.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

DEPEND=">=media-libs/libsndfile-1"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:-O3::' configure
	# libsndfile doesn't like -std=c99 on Solaris
	sed -i -e 's:-std=c99::' configure
	# Needed for FreeBSD to get a sane .so versioning.
	elibtoolize
}

src_install() {
	emake DESTDIR="${D}" pkgdocdir="${EPREFIX}/usr/share/doc/${PF}" \
		install || die "emake install failed."
	dodoc AUTHORS ChangeLog README TODO
	prepalldocs
}
