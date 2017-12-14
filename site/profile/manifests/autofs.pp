class profile::autofs {
  # enable browse mode in autofs.conf
  file { '/etc/autofs.conf':
    ensure          => 'present',
    owner           => 'root',
    group           => 'root',
    mode            => '0644',
    source          => 'puppet:///files/autofs/autofs.conf',
    notify          => Service['autofs'],
  }

  class { 'autofs':
    mount_files     => {
      job           => {
        mountpoint  => '/job',
        file_source => 'puppet:///files/autofs/auto.job',
      },
      net           => {
        mountpoint  => '/net',
        file_source => 'puppet:///files/autofs/auto.net',
      }
    }
  }
}
