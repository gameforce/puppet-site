install
url --url http://kam1/centos/7.3/os/x86_64
lang en_US.UTF-8
keyboard us
timezone --utc America/Vancouver
network --noipv6 --onboot=yes --bootproto dhcp
authconfig --enableshadow --enablemd5
rootpw --iscrypted $6$yshB3fNH$gNYCCumlYwENi31r/LYBe4jAqtLsXW1HnlaroUSJtgLK5nUAc8rXu2jdOAbUozuIjmJ2ZKv.N4S4.UwuftrQn/
firewall --disabled
selinux --disabled
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
repo --name CentOS-Base --baseurl http://kam1/centos/7/os/x86_64
repo --name epel --baseurl=http://dl.fedoraproject.org/pub/epel/6/x86_64/

# Package Selection
%packages --nobase --ignoremissing
@core
-biosdevname
@development-and-creative-workstation
@fonts
@gnome-desktop
@graphical-administration-tools
@input-methods
@multimedia
@x-window-system
@x11
epel-release
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
xorg-x11-fonts-100dpi
xorg-x11-fonts-75dpi
xorg-x11-fonts-ISO8859-1-100dpi
xorg-x11-fonts-ISO8859-1-75dpi
%end

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
yum -y install kmod-nvidia-340xx 
## google chrome repo and browser install
yum localinstall -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
##/opt/puppetlabs/bin/puppet agent --test
) 2>&1 | /usr/bin/tee /var/log/install-post-sh.log
chvt 1
%end
