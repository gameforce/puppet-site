# Configure dconf defaults for gnome3
class profile::dconf {

  #notify {"NEW: testing new bits":}
  file { '/etc/ssh/sshd_config':
    ensure    => 'present',
    owner     => 'root',
    group     => 'root',
    mode      => '0600',
    source    => 'puppet:///files/ssh/sshd_config',
  }

  file { '/etc/ssh/sshd_config':
    ensure    => 'present',
    owner     => 'root',
    group     => 'root',
    mode      => '0600',
    source    => 'puppet:///files/ssh/sshd_config',
  }
}
