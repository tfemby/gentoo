# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

DESCRIPTION="Perl script to convert HTML files into formatted LaTeX"
HOMEPAGE="https://html2latex.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.gz"
LICENSE="GPL-2+"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ppc ppc64 ~riscv sparc x86"

IUSE="imagemagick libwww"

DEPEND="dev-perl/HTML-Tree
	dev-perl/XML-Simple
	imagemagick? ( media-gfx/imagemagick )
	libwww? ( dev-perl/libwww-perl )"
RDEPEND="${DEPEND}"

src_configure() {
	# HTML::LaTex
	cd HTML || die
	perl-module_src_configure
}

src_compile() {
	# HTML::LaTex
	cd HTML || die
	perl-module_src_compile
}

src_install() {
	dobin html2latex
	doman html2latex.1
	dodoc README TODO

	# HTML::LaTex
	cd HTML || die
	perl-module_src_install

	# rm unwanted README.win
	rm "${ED}"/usr/share/doc/${PF}/README.win.txt || die
}
