class profile::kickstart {
   # install tftp
   package { 'tftp-server': ensure => 'installed', }

   # pxelinux.cfg directory
   file { '/var/lib/tftpboot/pxelinux.cfg':
     ensure => 'directory',
     owner  => 'root',
     group  => 'root',
     mode   => '0755',
   }

   # pxe default menu
   file { '/var/lib/tftpboot/pxelinux.cfg/default':
     ensure => 'present',
     owner  => 'root',
     group  => 'root',
     mode   => '0644',
     source => 'puppet:///files/pxeboot/default',
     # notify =>  Service['tftp'],
     # Server Error: Invalid relationship: File[/var/lib/tftpboot/pxelinux.cfg/default] { notify => Service[tftp.service] }, because Service[tftp.service] doesn't seem to be in the catalog
   }

   # kickstart setup
   file { '/var/www/html/vhosts/repo/ks/centos-server.ks':
     ensure => 'present',
     owner  => 'root',
     group  => 'root',
     mode   => '0644',
     source => 'puppet:///files/kickstart/centos-server.ks',
     notify =>  Service['httpd'],
   }
  # windows stuff here   
}
