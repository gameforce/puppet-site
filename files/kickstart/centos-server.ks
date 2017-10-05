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
skipx

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
yum -y update
yum -y install puppet 
) 2>&1 | /usr/bin/tee /var/log/install-post-sh.log
chvt 1
%end
