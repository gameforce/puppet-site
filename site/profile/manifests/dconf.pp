# Configure dconf defaults for gnome3
class profile::dconf {

  # used by desktop and
  desktop::gnome exec { 'dconf_update': command => '/usr/bin/dconf update', refreshonly => true, require => Package['dconf'], }
  
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
    notify    => Exec['dconf_update'],
  }
}
