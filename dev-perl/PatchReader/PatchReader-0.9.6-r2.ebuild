# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TMANNERM
DIST_VERSION=0.9.6
inherit perl-module

DESCRIPTION="Module for reading diff-compatible patch files"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"

RDEPEND="
	virtual/perl-File-Temp
"
BDEPEND="${RDEPEND}
"
