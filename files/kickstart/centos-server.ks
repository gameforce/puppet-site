install
url --url http://repo/centos/7.3/os/x86_64
lang en_US.UTF-8
keyboard us
timezone --utc America/Vancouver
network --noipv6 --onboot=yes --bootproto=dhcp --hostname=query
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

# Disk Partitioning
clearpart --all --initlabel
part /boot --size 500 --fstype ext2
part / --size 8192 --grow --fstype xfs
part swap --size 2048 --fstype swap
# END of Disk Partitioning

# Make sure we reboot into the new system when we are finished
reboot

# Package Repositories
repo --name CentOS-Base --baseurl http://repo/7/os/x86_64
repo --name stellar --baseurl http://repo/stellar/x86_64/

# Package Selection
%packages --nobase --ignoremissing
@core
-biosdevname
wget
sudo
perl
nmap
git
nfs-utils
autofs
xfsprogs
puppet-agent
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

# Configure puppet
mkdir -p /etc/puppetlabs/facter/facts.d

# Add in local facts
echo "systype=server" > /etc/puppetlabs/facter/facts.d/systype.txt

# Sync time
/usr/sbin/ntpdate clock
/sbin/hwclock -wu

# bootstap puppet -- once we have our hostname set
#echo "Running puppet for the first time..."
#sleep 5
#/opt/puppetlabs/bin/puppet agent --test
#/opt/puppetlabs/bin/puppet agent --test

#Tell us we have reached the end
echo "We have reached the end of the post-install script"
) 2>&1 | /usr/bin/tee /var/log/install-post-sh.log
chvt 1
%end
