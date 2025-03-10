# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{10..12} )

inherit linux-info udev xdg distutils-r1

DESCRIPTION="Linux Device Manager for Logitech Unifying Receivers and Paired Devices"
HOMEPAGE="https://pwr-solaar.github.io/Solaar/"
if [[ ${PV} =~ 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pwr-Solaar/Solaar"
else
	SRC_URI="https://github.com/pwr-Solaar/Solaar/archive/${PV/_rc/rc}.tar.gz -> ${P/_rc/rc}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 x86"
	S="${WORKDIR}"/Solaar-${PV/_rc/rc}
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc appindicator libnotify"

RDEPEND="
	acct-group/plugdev
	$(python_gen_cond_dep '
		dev-python/evdev[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/python-xlib[${PYTHON_USEDEP}]
		>=dev-python/pyudev-0.13[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]

	')
	x11-libs/gtk+:3[introspection]
	appindicator? ( dev-libs/libayatana-appindicator )
	libnotify? ( x11-libs/libnotify[introspection] )"
# libayatana-appindicator & libnotify are entirely optional and detected at runtime

CONFIG_CHECK="~HID_LOGITECH_DJ ~HIDRAW"

python_prepare_all() {
	# don't autostart (bug #494608)
	sed -i \
		-e '/yield autostart_path/d' \
		setup.py || die

	sed -i -r \
		-e '/yield.*udev.*rules.d/{s,/etc,/lib,g}' \
		setup.py || die

	# grant plugdev group rw access
	sed -i 's/#MODE=/MODE=/' rules.d/42-logitech-unify-permissions.rules || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	dodoc docs/devices.md CHANGELOG.md
	if use doc; then
		dodoc -r docs/*
	else
		newdoc docs/index.md README.md
	fi
	udev_dorules "${S}"/rules.d/42-logitech-unify-permissions.rules
}

pkg_postinst() {
	udev_reload
	xdg_pkg_postinst
}

pkg_postrm() {
	udev_reload
	xdg_pkg_postrm
}
