text
skipx
install
url --url http://repo/centos/7.3/os/x86_64

# Custom repos
repo --name=updates --baseurl=http://centos.fastbull.org/centos/6/updates/x86_64/
repo --name=epel --baseurl=http://download.fedoraproject.org/pub/epel/7/x86_64/
repo --name=puppetlabs --baseurl=http://yum.puppetlabs.com/el/7/PC1/x86_64/
repo --name=puppetlabs_dependencies --baseurl=http://yum.puppetlabs.com/el/7/dependencies/x86_64/
repo --name stellar --baseurl http://repo/stellar/x86_64/

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

# Network settings
%pre
#!/bin/bash
echo -n "Enter FQDN Hostname: " > /dev/tty1
read HOSTN
echo -n "Enter IP Address: " > /dev/tty1
read IP
echo -n "Enter the Netmask: " > /dev/tty1
read MASK
echo -n "Enter Gateway: " > /dev/tty1
read GW
echo -n "Enter Nameserver: " > /dev/tty1
read DNS
echo "network --device eth0 --bootproto=static --ip=${IP} --netmask=${MASK} --gateway=${GW} --nameserver=${DNS} --hostname=${HOSTN}" > /tmp/network.txt
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

#!/bin/bash
# bring in hostname collected from %pre, then source it
cp -Rvf /etc/sysconfig/network /mnt/sysimage/etc/sysconfig/network
cp -Rvf /etc/sysconfig/resolv.conf /mnt/sysimage/etc/resolv.conf
# Set-up eth0 with hostname
cp /etc/sysconfig/network-scripts/ifcfg-eth0  /mnt/sysimage/etc/sysconfig/network-scripts/ifcfg-eth0

# force hostname change
/mnt/sysimage/bin/hostname $HOSTNAME
rhn-profile-sync

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
