# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/timezone-data/timezone-data-2007b.ebuild,v 1.1 2007/02/12 15:46:53 vapier Exp $

EAPI="prefix"

inherit eutils toolchain-funcs flag-o-matic

code_ver=${PV}
data_ver=${PV}
DESCRIPTION="Timezone data (/usr/share/zoneinfo) and utilities (tzselect/zic/zdump)"
HOMEPAGE="ftp://elsie.nci.nih.gov/pub/"
SRC_URI="ftp://elsie.nci.nih.gov/pub/tzdata${data_ver}.tar.gz
	ftp://elsie.nci.nih.gov/pub/tzcode${code_ver}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PN}-2005n-makefile.patch
	tc-is-cross-compiler && cp -pR "${S}" "${S}"-native
}

src_compile() {
	tc-export CC
	use elibc_FreeBSD && append-flags -DSTD_INSPIRED #138251
	if use nls ; then
		use elibc_glibc || append-ldflags -lintl #154181
		export NLS=1
	else
		export NLS=0
	fi
	emake || die "emake failed"
	if tc-is-cross-compiler ; then
		make -C "${S}"-native CC=$(tc-getBUILD_CC) zic || die
	fi
}

src_install() {
	local zic=""
	tc-is-cross-compiler && zic="zic=${S}-native/zic"
	make install ${zic} DESTDIR="${D}${EPREFIX}" || die
	rm -rf "${ED}"/usr/share/zoneinfo-leaps
	dodoc README Theory
	dohtml *.htm *.jpg
}

pkg_config() {
	# make sure the /etc/localtime file does not get stale #127899
	local tz=$(source "${EROOT}"/etc/conf.d/clock ; echo ${TIMEZONE})
	if [[ -z ${tz} ]] ; then
		if [[ ! -e ${EROOT}/etc/localtime ]] ; then
			cp -f "${EROOT}"/usr/share/zoneinfo/Factory "${EROOT}"/etc/localtime
		fi
		ewarn "You do not have TIMEZONE set in /etc/conf.d/clock."
		ewarn "Skipping auto-update of /etc/localtime."
		return 0
	fi

	if [[ ! -e ${EROOT}/usr/share/zoneinfo/${tz} ]] ; then
		eerror "You have an invalid TIMEZONE setting in ${EPREFIX}/etc/conf.d/clock."
		eerror "Your ${EPREFIX}/etc/localtime has been reset to Factory; enjoy!"
		tz="Factory"
	fi
	einfo "Updating ${EPREFIX}/etc/localtime with ${EPREFIX}/usr/share/zoneinfo/${tz}"
	[[ -L ${EROOT}/etc/localtime ]] && rm -f "${EROOT}"/etc/localtime
	cp -f "${EROOT}"/usr/share/zoneinfo/"${tz}" "${EROOT}"/etc/localtime
}

pkg_postinst() {
	pkg_config
}
