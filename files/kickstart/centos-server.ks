#############################################################################
# Kickstart for CentOS 7
# ###########################################################################
# This file is managed by puppet.
#
install
text
network --noipv6 --onboot=yes --bootproto dhcp
#url --url http://repo/centos/7/os/x86_64
url --url http://repo/centos/7.4/

###########################
#Localisation settings
###########################
lang en_US.UTF-8
keyboard us
timezone --utc America/Vancouver
authconfig --enableshadow --enablemd5
rootpw --iscrypted $6$yshB3fNH$gNYCCumlYwENi31r/LYBe4jAqtLsXW1HnlaroUSJtgLK5nUAc8rXu2jdOAbUozuIjmJ2ZKv.N4S4.UwuftrQn/
firewall --disabled
selinux --disabled
firstboot --disabled
eula --agreed

#Disable kdump
%addon com_redhat_kdump --disable
%end

############################
#Repos
############################
repo --name epel --baseurl=http://repo/epel
repo --name stellar --baseurl=http://repo/stellar/x86_64

# NO ADDITIONAL REPOS AT THIS TIME

############################
#HDD Configuration
############################
zerombr
clearpart --all --initlabel
bootloader --location=mbr --append="rdblacklist=nouveau"
part /boot --size 500 --fstype ext3
part / --size 8192 --grow --fstype xfs
part swap --size 2048 --fstype swap

#############################
#Packages to be installed
#############################
%packages --nobase --ignoremissing
@core
@platform-vmware --nodefaults
epel-release
curl
net-tools
wget
sudo
perl
nmap
git
nfs-utils
gcc
autofs
xfsprogs
samba
tcsh
puppet
ntp
%end

##############################################
# POST INSTALL SCRIPTS
##############################################

%post --interpreter /bin/bash

# Allow user to see this script on a console
exec < /dev/tty3 > /dev/tty3 2>&1
chvt 3

# Clean out any old certificates on the puppetca that may exist for this host
# certname=`hostname`
# curl "http://puppetca/cgi-bin/cleancert.cgi?${certname}"

# variable to say machine is a server
mkdir -p /etc/puppetlabs/facter/facts.d
echo "systype=server" > /etc/puppetlabs/facter/facts.d/systype.txt

# Disable the default external repos
sed -i "s/enabled=1/enabled=0/g" /etc/yum.repos.d/*.repo

#Configure local repos
cat >> /etc/yum.repos.d/stellar-centos.repo <<'EOF'
[stellar-centos]
name=Stellar CentOS Linux Repo - x86_64
baseurl=http://repo/centos/7.4
enabled=1
gpgcheck=0
enablegroups=1
EOF

#Run puppet so the clients configuration is applied before reboot
echo executing puppet run for $HOSTNAME
/opt/puppetlabs/bin/puppet agent --test

# Switch back to the kickstart display

clear
chvt 1

%end
