class profile::pxeboot {
   # pxe default menu
   file { '/var/lib/tftpboot/pxelinux.cfg/default':
     ensure => 'present',
     owner  => 'root',
     group  => 'root',
     mode   => '0755',
     source => 'puppet:///files/pxeboot/default',
     notify =>  Service['tftp'],
   }
