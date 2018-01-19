# Configure dconf defaults for gnome3
class profile::dconf {
  
  file { '/etc/dconf/profile/gdm':
    ensure    => 'present',
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    source    => 'puppet:///files/dconf/gdm',
    notify    => Exec['dconf update'],
  }

  file { '/etc/dconf/db/gdm.d/00-login-screen':
    ensure    => 'present',
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    source    => 'puppet:///files/dconf/00-login-screen',
    notify    => Exec['dconf update'],
  }

  #file { '/etc/dconf/db/system.d/common':
  #  ensure    => 'present',
  #  owner     => 'root',
  #  group     => 'root',
  #  mode      => '0644',
  #  source    => 'puppet:///files/dconf/common',
  #  notify    => Exec['dconf update'],
  #}

  exec { "dconf update":
    command     => "/usr/bin/dconf update",
    user        => 'root',
    group       => 'root',
    refreshonly => true,
  }
}
