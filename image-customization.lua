packages{
	'gluon-web-autoupdater',
	'haveged',
	'iwinfo',
	'gluon-segment-mover',
	'ecdsautils',
	'respondd-module-airtime',
	'ffh-cli-scripts',
}

features {
	'autoupdater',
	'authorized-keys',
	'config-mode-domain-select',
	'config-mode-geo-location-osm',
	'ebtables-filter-multicast',
	'ebtables-filter-ra-dhcp',
	'ebtables-limit-arp',
	'mesh-batman-adv-15',
	'mesh-vpn-wireguard',
	'radv-filterd',
	'radvd',
	'respondd',
	'setup-mode',
	'status-page',
	'web-advanced',
	'web-private-wifi',
	'web-wizard',
}

pkgs_usb = {
	'usbutils',
	'kmod-usb-core',
	'kmod-usb2',
}

pkgs_hid = {
    'kmod-usb-hid',
    'kmod-hid-generic',
}

pkgs_usb_serial = {
	'kmod-usb-serial',
	'kmod-usb-serial-ftdi',
	'kmod-usb-serial-pl2303',
}

pkgs_usb_storage = {
	'block-mount',
	'blkid',
	'kmod-fs-ext4',
	'kmod-fs-ntfs',
	'kmod-fs-vfat',
	'kmod-usb-storage',
	'kmod-usb-storage-extras',-- Card Readers
	'kmod-usb-storage-uas', -- USB Attached SCSI (UAS/UASP)
	'kmod-nls-base',
	'kmod-nls-cp1250',      -- NLS Codepage 1250 (Eastern Europe)
	'kmod-nls-cp1251',      -- NLS Codepage 1251 (Russian)
	'kmod-nls-cp437',       -- NLS Codepage 437 (United States, Canada)
	'kmod-nls-cp775',       -- NLS Codepage 775 (Baltic Rim)
	'kmod-nls-cp850',       -- NLS Codepage 850 (Europe)
	'kmod-nls-cp852',       -- NLS Codepage 852 (Europe)
	'kmod-nls-cp866',       -- NLS Codepage 866 (Cyrillic)
	'kmod-nls-iso8859-1',   -- NLS ISO 8859-1 (Latin 1)
	'kmod-nls-iso8859-13',  -- NLS ISO 8859-13 (Latin 7; Baltic)
	'kmod-nls-iso8859-15',  -- NLS ISO 8859-15 (Latin 9)
	'kmod-nls-iso8859-2',   -- NLS ISO 8859-2 (Latin 2)
	'kmod-nls-utf8',        -- NLS UTF-8
}

pkgs_tools = {
	'bash',
	'tcpdump',
	'vnstat',
	'iperf',
	'iperf3',
	'socat',
	'usbutils',
}

pkgs_usb_net = {
	'kmod-mii',
	'kmod-nls-base',
	'kmod-usb-net',
	'kmod-usb-net-asix',
	'kmod-usb-net-asix-ax88179',
	'kmod-usb-net-cdc-eem',
	'kmod-usb-net-cdc-ether',
	'kmod-usb-net-cdc-mbim',
	'kmod-usb-net-cdc-ncm',
	'kmod-usb-net-cdc-subset',
	'kmod-usb-net-dm9601-ether',
	'kmod-usb-net-hso',
	'kmod-usb-net-huawei-cdc-ncm',
	'kmod-usb-net-ipheth',
	'kmod-usb-net-kalmia',
	'kmod-usb-net-kaweth',
	'kmod-usb-net-mcs7830',
	'kmod-usb-net-pegasus',
	'kmod-usb-net-qmi-wwan',
	'kmod-usb-net-rndis',
	'kmod-usb-net-rtl8150',
	'kmod-usb-net-rtl8152',
	'kmod-usb-net-sierrawireless',
	'kmod-usb-net-smsc95xx',
}

pkgs_pci_net = {
	'kmod-sky2',
	'kmod-r8169',
	'kmod-forcedeth',
	'kmod-8139too',
}

pkgs_pci = {
	'pciutils',
	'kmod-bnx2', -- Broadcom NetExtreme BCM5706/5708/5709/5716
}
	
if device({
        'zte,mf281',
        'glinet,gl-xe300',
        'glinet,gl-ap1300',
        'zte,mf289f',
        'wavlink,ws-wn572hp3-4g',
        'tplink,tl-mr6400-v5',
    }) then
    features {
        'web-cellular',
}
end

include_usb = false

if target('x86') then
	include_usb = true
end

if include_usb then
    packages(pkgs_usb)
    packages(pkgs_usb_net)
    packages(pkgs_usb_serial)
    packages(pkgs_usb_storage)
end

-- device has no reset button and requires a special package to go into setup mode
-- https://github.com/freifunk-gluon/community-packages/tree/master/ffda-network-setup-mode
if device({
    'zyxel-nwa55axe',
}) then
    packages {'ffda-network-setup-mode'}
end

if target('x86', '64') then
    packages {'qemu-ga'}
end

if target('x86') and not target('x86', 'legacy') then
    packages(pkgs_pci)
    packages(pkgs_pci_net)
    packages(pkgs_tools)	
end

if target('bcm27xx') then
    packages(pkgs_hid)
end