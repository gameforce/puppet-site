text
skipx
install
url --url http://repo/centos/7.3/os/x86_64

#TODO Add nux, elrepo, google
# Custom repos 
repo --name=updates --baseurl=http://centos.fastbull.org/centos/6/updates/x86_64/
repo --name=epel --baseurl=http://download.fedoraproject.org/pub/epel/7/x86_64/
repo --name=puppetlabs --baseurl=http://yum.puppetlabs.com/el/7/PC1/x86_64/
repo --name=puppetlabs_dependencies --baseurl=http://yum.puppetlabs.com/el/7/dependencies/x86_64/
repo --name site --baseurl http://repo/stellar/x86_64/

# General settings
lang en_US.UTF-8
keyboard us
rootpw --iscrypted $6$yshB3fNH$gNYCCumlYwENi31r/LYBe4jAqtLsXW1HnlaroUSJtgLK5nUAc8rXu2jdOAbUozuIjmJ2ZKv.N4S4.UwuftrQn/
firewall --disabled
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone America/Vancouver
eula --agreed
%addon com_redhat_kdump --disable
%end

# Disk Partitioning
bootloader --location=mbr
zerombr
clearpart --all --initlabel
part /boot --size 500 --fstype ext2
part / --size 8192 --grow --fstype xfs
part swap --size 2048 --fstype swap

# Services
services --enabled=postfix,network,ntpd,ntpdate

# Reboot
reboot

# Packages
%packages --nobase
epel-release
puppetlabs-release-pc1
puppet-agent
openssh-clients
openssh-server
acpid
autofs
cronie
crontabs
git
logrotate
perl
nfs-utils
nmap
ntp
ntpdate
rsync
sudo
which
wget
yum
xfsprogs
%end

%post --log=/root/install-post.log
exec < /dev/tty3 > /dev/tty3
chvt 3
echo
echo "################################"
echo "# Running Post Configuration   #"
echo "################################"
(

# network setup
hostname=""
ip=""
netmask=""
gw=""
opts=""
answer="n"
device="eth0"
hwaddr=`ifconfig $device | grep -i hwaddr | sed -e 's#^.*hwaddr[[:space:]]*##I'`
dns1="172.16.10.2"
dns2="8.8.8.8"

curTTY=`tty`
exec < $curTTY > $curTTY 2> $curTTY
clear

while [ x"$answer" != "xy" ] && [ x"$answer" != "xY" ] ; do
        echo -n "enter hostname: "; read hostname
        echo -n "enter ip: "; read ip
        echo -n "enter netmask: "; read netmask
        echo -n "enter default gw: "; read gw
        echo

        echo You entered:
        echo -e "\thostname: $hostname"
        echo -e "\tip: $ip"
        echo -e "\tnetmask: $netmask"
        echo -e "\tdefault gw: $gw"
        echo -n "Is this correct? [y/n] "; read answer
done

if [ x"$opts" = "xy" ] ; then
        opts=""
fi

sed -i -e 's#^\(HOSTNAME=\).*$#\1'"$hostname"'#' /etc/sysconfig/network
echo GATEWAY=$gw >> /etc/sysconfig/network

echo DEVICE=$device > $scrFile
echo BOOTPROTO=static >> $scrFile
echo ONBOOT=yes >> $scrFile
echo NM_CONTROLLED=no >> $scrFile
echo HWADDR=$hwaddr >> $scrFile
echo IPADDR=$ip >> $scrFile
echo NETMASK=$netmask >> $scrFile
echo DNS1=$dns1 >> $scrFile
echo DNS2=$dns2 >> $scrFile

if [ "x$opts" != "x" ] ; then
        echo 'ETHTOOL_OPTS="'"$opts"'"' >> $scrFile
fi
# end network setup

PATH=/net/software/bin:/opt/puppetlabs/bin:/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin
export PATH

# Configure puppet
mkdir -p /etc/puppetlabs/facter/facts.d
echo "systype=server" > /etc/puppetlabs/facter/facts.d/systype.txt

# Sync time and update
/usr/sbin/ntpdate clock
/sbin/hwclock -wu
/usr/bin/yum -y update

# bootstap puppet
echo -n "Running puppet for the first time..."
sleep 5
/opt/puppetlabs/bin/puppet agent --test
/opt/puppetlabs/bin/puppet agent --test

#Tell us we have reached the end
echo "We have reached the end of the post-install script"
) 2>&1 | /usr/bin/tee /var/log/install-post-sh.log
chvt 1
%end
