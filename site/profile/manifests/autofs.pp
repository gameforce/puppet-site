# autofs profile
class profile::autofs {
  # enable browse mode in autofs.conf
  file { '/etc/autofs.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///files/autofs/autofs.conf',
    notify => Service['autofs'],
  }

  file { '/etc/auto.smb.ad0':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///files/autofs/auto.smb.ad0',
    notify => Service['autofs'],
  }

  class { 'autofs':
    mount_files     => {
      job => {
        mountpoint  => '/job',
        file_source => 'puppet:///files/autofs/auto.job',
      },
      net => {
        mountpoint  => '/net',
        file_source => 'puppet:///files/autofs/auto.net',
      },
      cifs => {
        mountpoint  => '/cifs',
        file_source => 'puppet:///files/autofs/auto.cifs',
      }
    }
  }
}
