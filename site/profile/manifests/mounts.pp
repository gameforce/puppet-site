class profile::mounts { 
  # enable browse mode in autofs.conf
  file_line { 'browse_mode':
    path  => '/etc/autofs.conf',
    line  => 'browse_mode = "yes"',
    match => '^browse_mode*',
  }

  class { 'autofs':
    mount_files => {
      job  => {
        mountpoint  => '/job',
        file_source => 'puppet:///files/autofs/auto.job',
      },
      net  => {
        mountpoint  => '/net',
        file_source => 'puppet:///files/autofs/auto.net',
      }
    }
  }
}
