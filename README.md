## Puppet agent/master setup for CentOS 7
#### Install and configure ntp and a few requirements
```
$ yum install ntp ntpdate wget git
$ ntpdate -u 0.centos.pool.ntp.org
```
#### List the available time zones.
```
$ timedatectl list-timezones
```
#### Set the time zone using the following command.
```
$ timedatectl set-timezone America/Vancouver
```
#### Get the PupperLabs repository, install it and update the repo.
```
$ wget https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
$ yum install puppetlabs-release-pc1-el-7.noarch.rpm
$ yum -y update
```
#### Install the Puppet server using below command, do not start it yet.
```
$ yum install -y puppetserver
```
#### If you need to change the value of memory allocation, edit the below file.
```
$ vi /etc/sysconfig/puppetserver
```
#### Change the value shown like below
```
JAVA_ARGS="-Xms2g -Xmx2g
```
#### Use 1024 or 512 for a vm, otherwise leave the default 2gb:
```
JAVA_ARGS="-Xms1g -Xmx1g"
```
#### Copy the puppet configs over from files/puppet directory.
```
$ cp files/puppet/* /etc/puppetlabs/puppet/
```
#### Start and enable the Puppet Server.
```
$ systemctl start puppetserver
$ systemctl enable puppetserver
```
#### Install the puppet agent using below command. As of newer versions it should already be installed
```
$ yum install -y puppet-agent
```
#### Start puppet agent on the node and make it start automatically on system boot.
```
$ /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
```
#### Log into the puppet master server and run below command to view outstanding cert sign requests.
```
$ sudo /opt/puppetlabs/bin/puppet cert list
"client.domain.local" (SHA256) 40:7C:E2:2E:09:4B:86:1A:B8:D5:4A:C0:CE:FF:4F:3F:BB:F9:C5:2F:99:13:51:FE:C7:22:F3:FE:6A:65:48:85
```
#### Sign the requests.
```
$ sudo /opt/puppetlabs/bin/puppet cert sign client.domain.local
```
#### To sign all the certificate signing requests in one command.
```
$ sudo /opt/puppetlabs/bin/puppet cert sign --all
```
#### To revoke a certificate
```
$ sudo /opt/puppetlabs/bin/puppet cert clean hostname
```
#### List all of the signed and unsigned requests on the master. Signed requests start with “+“.
```
$ sudo /opt/puppetlabs/bin/puppet cert list --all
```
#### Once the Puppet master is signed your client certificate, run the following command on the client machine to test it.
```
$ sudo /opt/puppetlabs/bin/puppet agent --test
```
#### Setup ssh keys for the root user on the puppet master
```
$ ssh-keygen -t rsa -C root@puppet
```
#### Add your key to your git repo so that you can clone it
```
$ cat .ssh/id_rsa.pub (and paste into new key for gitlab/gihub)
```
#### Now clone your puppet core repo
```
$ mkdir git;cd git;git clone git@github.com/gameforce/puppet-site puppet
```
#### Install and setup r10k and deploy
```
$ mkdir /etc/puppetlabs/r10k
$ cp files/puppet/r10k.yaml /etc/puppetlabs/r10k
$ /opt/puppetlabs/puppet/bin/gem install r10k
$ /opt/puppetlabs/puppet/bin/r10k deploy environment -pv
$ /opt/puppetlabs/puppet/bin/puppet agent --test
```
### Webhook setup
