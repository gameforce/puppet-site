install
url --url http://repo/centos/7.3/os/x86_64
lang en_US.UTF-8
keyboard us
timezone --utc America/Vancouver
#%include /tmp/network.txt

%pre
# Set the hostname
#!/bin/bash
myip=$(ip route get 8.8.8.8 | awk '{print $NF;exit}')
myhostname=box$(ip route get 172.16.10.2 | awk -F. '{print $NF;exit}')
mymac=$(ip link show eth0 | tail -1 | awk '{print $2}' | sed 's/://g')
mkdir /mnt/tmp
mount -o nolock syn:/volume1/systems /mnt/tmp
cp -r /mnt/tmp/tools/.ssh /root
umount -l /mnt/tmp
ssh -o StrictHostKeyChecking=no administrator@ads1 "Add-DhcpServerv4Reservation -ScopeId 172.16.0.0 -IPAddress $myip -ClientId $mymac -Description PXE -Name $myhostname"
echo -e "NETWORKING=yes\nHOSTNAME=$myhostname" > /etc/sysconfig/network
echo -e "Setting IP to $myip and HOSTNAME to $myhostname and adding reservation"
/bin/hostname #myhostname.stellarcreative.lab
%end

network --noipv6 --onboot=yes --bootproto dhcp
authconfig --enableshadow --enablemd5
rootpw --iscrypted $6$yshB3fNH$gNYCCumlYwENi31r/LYBe4jAqtLsXW1HnlaroUSJtgLK5nUAc8rXu2jdOAbUozuIjmJ2ZKv.N4S4.UwuftrQn/
firewall --disabled
selinux --disabled
firstboot --disabled
%addon com_redhat_kdump --disable
%end
bootloader --location=mbr --driveorder=sda --append="crashkernel=auth rhgb"

# Accept license
eula --agreed

# Don't use GUI
text

# Configure X
xconfig --startxonboot --defaultdesktop=GNOME

# Disk Partitioning
clearpart --all --initlabel
part /boot --size 500 --fstype ext3
part / --size 8192 --grow --fstype xfs
part swap --size 2048 --fstype swap
# END of Disk Partitioning

# Make sure we reboot into the new system when we are finished
reboot

# Package Repositories
repo --name CentOS-Base --baseurl http://repo/7/os/x86_64

# Package Selection
%packages --nobase --ignoremissing
@core
-biosdevname
-gnome-initial-setup
@fonts
@gnome-desktop
@graphical-administration-tools
@input-methods
@x-window-system
@x11
wget
sudo
perl
nmap
git
nfs-utils
autofs
xfsprogs
samba
## needed by maya
libXp
compat-libtiff3
gamin
libpng12
wget
tcsh
Thunar
audiofile
audiofile-devel
xorg-x11-fonts-100dpi
xorg-x11-fonts-75dpi
xorg-x11-fonts-ISO8859-1-100dpi
xorg-x11-fonts-ISO8859-1-75dpi
%end

# Disable initial setup
services --disabled="initial-setup-graphical"

%pre
%end

%post --log=/root/install-post.log
exec < /dev/tty3 > /dev/tty3
chvt 3
echo
echo "################################"
echo "# Running Post Configuration   #"
echo "################################"
(
PATH=/net/software/bin:/opt/puppetlabs/bin:/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin
export PATH

# install puppet, nux, kmod-nvidia and update
rpm -ivh https://yum.puppetlabs.com/el/7/PC1/x86_64/puppetlabs-release-pc1-1.1.0-5.el7.noarch.rpm
rpm -ivh http://ftp.osuosl.org/pub/elrepo/elrepo/el7/x86_64/RPMS/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum -y update
yum -y install puppet
yum -y install kmod-nvidia
## google chrome repo and browser install
yum localinstall -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
# bootstap puppet
echo "Running puppet for the first time..."
sleep 5
/opt/puppetlabs/bin/puppet agent --test
/opt/puppetlabs/bin/puppet agent --test
#Tell us we have reached the end
echo "We have reached the end of the post-install script"
) 2>&1 | /usr/bin/tee /var/log/install-post-sh.log
chvt 1
%end
