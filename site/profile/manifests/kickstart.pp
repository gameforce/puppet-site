class profile::kickstart {

   # pxe default menu
   file { '/var/lib/tftpboot/pxelinux.cfg/default':
     ensure => 'present',
     owner  => 'root',
     group  => 'root',
     mode   => '0755',
     source => 'puppet:///files/pxeboot/default',
     notify =>  Service['tftp'],
   }

   # kickstart setup
   file { '/var/www/html/vhosts/repo/ks/centos-desktop.ks':
     ensure => 'present',
     owner  => 'root',
     group  => 'root',
     mode   => '0755',
     source => 'puppet:///files/kickstart/centos-desktop.ks',
     notify =>  Service['httpd'],
   }

   file { '/var/www/html/vhosts/repo/ks/centos-server.ks':
     ensure => 'present',
     owner  => 'root',
     group  => 'root',
     mode   => '0755',
     source => 'puppet:///files/kickstart/centos-server.ks',
     notify =>  Service['httpd'],
   }

   file { '/var/www/html/vhosts/repo/ks/centos-virtualbox.ks':
     ensure => 'present',
     owner  => 'root',
     group  => 'root',
     mode   => '0755',
     source => 'puppet:///files/kickstart/centos-virtualbox.ks',
     notify =>  Service['httpd'],
   }
