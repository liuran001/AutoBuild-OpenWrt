#!/bin/bash
cd openwrt

mkdir -p turboacc_tmp ./package/turboacc
cd turboacc_tmp 
git clone https://github.com/chenmozhijin/turboacc -b package
cd ../package/turboacc
git clone https://github.com/fullcone-nat-nftables/nft-fullcone
git clone https://github.com/chenmozhijin/turboacc
mv ./turboacc/luci-app-turboacc ./luci-app-turboacc
rm -rf ./turboacc
cd ../..
cp -f turboacc_tmp/turboacc/hack-6.1/952-add-net-conntrack-events-support-multiple-registrant.patch ./target/linux/generic/hack-6.1/952-add-net-conntrack-events-support-multiple-registrant.patch
cp -f turboacc_tmp/turboacc/hack-6.1/953-net-patch-linux-kernel-to-support-shortcut-fe.patch ./target/linux/generic/hack-6.1/953-net-patch-linux-kernel-to-support-shortcut-fe.patch
cp -f turboacc_tmp/turboacc/pending-6.1/613-netfilter_optional_tcp_window_check.patch ./target/linux/generic/pending-6.1/613-netfilter_optional_tcp_window_check.patch
rm -rf ./package/libs/libnftnl ./package/network/config/firewall4 ./package/network/utils/nftables
mkdir -p ./package/network/config/firewall4 ./package/libs/libnftnl ./package/network/utils/nftables
cp -r ./turboacc_tmp/turboacc/shortcut-fe ./package/turboacc
cp -RT ./turboacc_tmp/turboacc/firewall4-$(grep -o 'FIREWALL4_VERSION=.*' ./turboacc_tmp/turboacc/version | cut -d '=' -f 2)/firewall4 ./package/network/config/firewall4
cp -RT ./turboacc_tmp/turboacc/libnftnl-$(grep -o 'LIBNFTNL_VERSION=.*' ./turboacc_tmp/turboacc/version | cut -d '=' -f 2)/libnftnl ./package/libs/libnftnl
cp -RT ./turboacc_tmp/turboacc/nftables-$(grep -o 'NFTABLES_VERSION=.*' ./turboacc_tmp/turboacc/version | cut -d '=' -f 2)/nftables ./package/network/utils/nftables
rm -rf turboacc_tmp
echo "# CONFIG_NF_CONNTRACK_CHAIN_EVENTS is not set" >> target/linux/generic/config-6.1
echo "# CONFIG_SHORTCUT_FE is not set" >> target/linux/generic/config-6.1

./scripts/feeds update -a
./scripts/feeds install -a

sed -i "s#hostname='ImmortalWrt'#hostname='BakaWrt'#g" package/base-files/files/bin/config_generate
sed -i "s#timezone='UTC'#timezone='Asia/Shanghai'#g" package/base-files/files/bin/config_generate
sed -i "s#system.ntp.server='time1.apple.com'#system.ntp.server='ntp.aliyun.com'#g" package/base-files/files/bin/config_generate
sed -i "s#system.ntp.server='time1.google.com'#system.ntp.server='time1.cloud.tencent.com'#g" package/base-files/files/bin/config_generate
sed -i "s#system.ntp.server='time.cloudflare.com'#system.ntp.server='time.ustc.edu.cn'#g" package/base-files/files/bin/config_generate

cp -f ../files/banner package/base-files/files/etc/
cp ../files/distfeeds.conf.1 package/system/opkg/files/
cp -f ../files/20_migrate-feeds package/system/opkg/files/

echo '127.0.0.1 bakawrt bakawrt.local' >> package/base-files/files/etc/hosts
echo '::1     bakawrt bakawrt.local' >> package/base-files/files/etc/hosts

cd package
rm -rf feeds/luci/luci-theme-argon
rm -rf feeds/luci/luci-app-argon-config

mkdir custom-packages
cd custom-packages
git clone https://github.com/jerrykuku/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config
git clone https://github.com/sirpdboy/netspeedtest
git clone https://github.com/Erope/openwrt_nezha
git clone https://github.com/linkease/istore
git clone https://github.com/linkease/nas-packages-luci
git clone https://github.com/linkease/nas-packages
git clone https://github.com/kenzok8/openwrt-packages kenzok8
git clone https://github.com/sirpdboy/luci-app-poweroffdevice
rm -rf kenzok8/luci-app-argon-config
rm -rf kenzok8/luci-theme-argon

cd ../..
