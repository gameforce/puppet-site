# Configure dconf defaults for gnome3
class profile::dconf {

  #notify {"NEW: testing new bits":}
  file { '/etc/dconf/profile/gdm':
    ensure    => 'present',
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    source    => 'puppet:///files/dconf/gdm',
  }

  file { '/etc/dconf/db/gdm.d/00-login-screen':
    ensure    => 'present',
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    source    => 'puppet:///files/dconf/00-login-screen',
    notify  => Exec['dconf_update'],
  }
}
