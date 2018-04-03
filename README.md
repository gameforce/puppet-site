## Puppet agent/master setup for ubuntu 17.04
#### Install and configure ntp
```
sudo apt-get install ntp ntpdate
sudo ntpdate -u 0.ubuntu.pool.ntp.org
```
#### List the available time zones.
```
$ timedatectl list-timezones
```
#### Set the time zone using the following command.
```
$ sudo timedatectl set-timezone America/Vancouver
```
#### Get the PupperLabs repository and install it.
```
$ wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
$ sudo dpkg -i puppetlabs-release-pc1-xenial.deb
$ sudo apt-get update
```
#### Install the Puppet server using below command, do not start it yet.
```
$ sudo apt-get install -y puppetserver
```
#### If you need to change the value of memory allocation, edit the below file.
```
$ sudo nano /etc/default/puppetserver
```
#### Change the value shown like below
```
JAVA_ARGS="-Xms2g -Xmx2g
```
#### Use 1024 or 512:
```
JAVA_ARGS="-Xms1g -Xmx1g"
```
#### Modify the Puppet master settings for your requirements.
```
$ sudo vim /etc/puppetlabs/puppet/puppet.conf
```
#### Place the below lines. Modify it according to your environment.
```
[master]
dns_alt_names = server.domain.local,server
[main]
certname = server.domain.local
server = server.domain.local
environment = production
runinterval = 1h
```
#### Start and enable the Puppet Server.
```
$ sudo systemctl start puppetserver
$ sudo systemctl enable puppetserver
```
#### Install the puppet agent using below command.
```
$ sudo apt-get install -y puppet-agent
```
#### Edit the puppet configuration file and set puppet master information and set “server” value to your master node name.
```
$ sudo vim /etc/puppetlabs/puppet/puppet.conf
[main]
certname = client.domain.local
server = server.domain.local
environment = production
runinterval = 1h
```
#### Start puppet agent on the node and make it start automatically on system boot.
```
$ sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
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
#### to revoke a certificate
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
#### TODO: git repo and manifests
```
more to come 
```
