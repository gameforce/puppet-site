class profile::ssh {

  # implement our own sshd_config
  file { '/etc/ssh/sshd_config':
    ensure    => 'present',
    owner     => 'root',
    group     => 'root',
    mode      => '0600',
    source    => 'puppet:///files/ssh/sshd_config',
  }

  # implement our version of the ssh client options
  file { '/etc/ssh/ssh_config':
    ensure    => 'present',
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    source    => 'puppet:///files/ssh/ssh_config',
  }

  service { sshd:
    ensure    =>  running,
    subscribe =>  File["/etc/ssh/sshd_config"],
  }
  # attempt to register dhcp reservation
  exec { 'ssh administrator@ads1 Get-DhcpServerv4Lease -IPAddress $myip | Add-DhcpServerv4Reservation':}
}
