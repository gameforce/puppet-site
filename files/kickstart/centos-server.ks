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
bootloader --location=mbr --driveorder=sda --append="rdblacklist=nouveau"
zerombr
clearpart --all --initlabel
part /boot --size 500 --fstype ext2
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
# PRE INSTALL SCRIPTS
##############################################

%pre
#!/bin/sh
#
# Pre-install script; will not cause Anaconda to abort, even if it
# returns non-zero return code
#

# Allow user to see this script on a console

exec < /dev/tty3 > /dev/tty3 2>&1
chvt 3

# Machines of different manufactures can use different types
# of disk. Select the disk for the OS install.

CANDIDATES="cciss/c0d0 sda vda"

for AUTO in $CANDIDATES ""; do
  if [ -b "/dev/$AUTO" ]; then
    break
  fi
done

# Allow user to select the disk for install

while true; do
  read -p "Enter destination disk, or ? for a list [$AUTO]: " M

  if [ "$M" == '?' ]; then
    echo
    (cd /sys/block && ls | grep -v '^loop' |
      grep -v '^ram' | sed -e 'y|!|/|' )
    echo
    continue
  fi

  if [ "$M" == '' ]; then
    M="$AUTO"
  fi

  if [ "$M" == '' ]; then
    continue
  fi

  if [ ! -b "/dev/$M" ]; then
    echo "/dev/$M not found" >&2
    continue
  fi

  break
done

echo "clearpart --drives=$M --all" > /tmp/root-disk

# Final confirmation from user

CONFIRM="no"
while [ "$CONFIRM" != "yes" ]; do
  echo
  echo '********************************************************************************'
  echo '*                              W A R N I N G                                   *'
  echo '*                                                                              *'
  echo '*        This process will install a completely new operating system           *'
  echo '*                                                                              *'
  echo '*      Do you wish to continue? (Type the entire word "yes" to proceed.)       *'
  echo '*                                                                              *'
  echo '********************************************************************************'
  echo
  read -p "Proceed with install to $M? " CONFIRM
done

# Switch back to the kickstart display

clear
chvt 1

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
