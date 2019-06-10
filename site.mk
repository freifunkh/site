GLUON_FEATURES := \
	autoupdater \
	config-mode-domain-select \
	config-mode-geo-location-osm \
	ebtables-filter-multicast \
	ebtables-filter-ra-dhcp \
	ebtables-limit-arp \
	mesh-batman-adv-15 \
	mesh-vpn-fastd \
	radv-filterd \
	radvd \
	respondd \
	setup-mode \
	status-page \
	web-advanced \
	web-private-wifi \
	web-wizard

GLUON_SITE_PACKAGES := \
	-gluon-web-autoupdater \
	ffho-autoupdater-wifi-fallback \
	ffho-web-autoupdater \
	haveged \
	iptables \
	iwinfo \
	respondd-module-airtime
# when removing ffho-web-autoupdater, remember to readd gluon-web-autoupdater again

GLUON_MULTIDOMAIN = 1

# support the USB stack
USB_PACKAGES_BASIC := \
	kmod-usb-core \
	kmod-usb2 \
	kmod-usb-hid

# FAT32 Support for USB
USB_PACKAGES_STORAGE := \
	block-mount \
	kmod-fs-ext4 \
	kmod-fs-vfat \
	kmod-usb-storage  \
	kmod-usb-storage-extras  \
	blkid  \
	swap-utils  \
	kmod-nls-cp1250  \
	kmod-nls-cp1251  \
	kmod-nls-cp437  \
	kmod-nls-cp775  \
	kmod-nls-cp850  \
	kmod-nls-cp852  \
	kmod-nls-cp866  \
	kmod-nls-iso8859-1  \
	kmod-nls-iso8859-13  \
	kmod-nls-iso8859-15  \
	kmod-nls-iso8859-2  \
	kmod-nls-koi8r  \
	kmod-nls-utf8

USB_PACKAGES_NET := \
	kmod-usb-net \
	kmod-usb-net-asix \
	kmod-usb-net-asix-ax88179 \
	kmod-usb-net-cdc-eem \
	kmod-usb-net-cdc-ether \
	kmod-usb-net-cdc-mbim \
	kmod-usb-net-cdc-ncm \
	kmod-usb-net-cdc-subset \
	kmod-usb-net-dm9601-ether \
	kmod-usb-net-hso \
	kmod-usb-net-huawei-cdc-ncm \
	kmod-usb-net-ipheth \
	kmod-usb-net-kalmia \
	kmod-usb-net-kaweth \
	kmod-usb-net-mcs7830 \
	kmod-usb-net-pegasus \
	kmod-usb-net-qmi-wwan \
	kmod-usb-net-rndis \
	kmod-usb-net-rtl8150 \
	kmod-usb-net-rtl8152 \
	kmod-usb-net-sierrawireless \
	kmod-usb-net-smsc95xx \
	kmod-mii \
	kmod-nls-base

NIC_PACKAGES_NET := \
	kmod-sky2 \
	kmod-r8169 \
	kmod-forcedeth \
	kmod-8139too

TOOLS_PACKAGES := \
	bash \
	tcpdump \
	vnstat \
	iperf \
	iperf3 \
	socat \
	usbutils

ifeq ($(GLUON_TARGET),x86-generic)
GLUON_SITE_PACKAGES += \
	kmod-usb-hid \
	$(NIC_PACKAGES_NET) \
	$(USB_PACKAGES_BASIC) \
	$(USB_PACKAGES_STORAGE) \
	$(USB_PACKAGES_NET) \
	$(TOOLS_PACKAGES)
endif

ifeq ($(GLUON_TARGET),x86-64)
GLUON_SITE_PACKAGES += \
	kmod-usb-hid \
	$(NIC_PACKAGES_NET) \
	$(USB_PACKAGES_BASIC) \
	$(USB_PACKAGES_STORAGE) \
	$(USB_PACKAGES_NET) \
	$(TOOLS_PACKAGES)
endif

ifeq ($(GLUON_DEBUG),1)
GLUON_SITE_PACKAGES += \
	valgrind \
	strace \
	gdb
endif

DEFAULT_GLUON_RELEASE := 1.0-$(shell date '+%Y%m%d')

# Allow overriding the release number from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)
GLUON_PRIORITY ?= 0
GLUON_LANGS ?= de en fr
GLUON_REGION ?= eu
GLUON_ATH10K_MESH ?= 11s

GLUON_BRANCH ?= stable
