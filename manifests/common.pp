# setup environment
$stellarpath = '/net/software/bin:/usr/lib64/qt-3.3/bin:/opt/puppetlabs/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:${PATH}'
file { "/etc/profile.d/stellar.sh":
  content => "export PATH=${stellarpath}",
  mode    => '0644'
}

# mod 'razorsedge-openvmtools', '1.1.0'
class { '::openvmtools':
  with_desktop => false,
}

# mod 'saz-motd', '2.4.0'
class { 'motd': }

# mod 'puppetlabs-ntp', '6.2.0'
class { '::ntp':
  servers => [ 'clock.stellarcreative.lab' ],
}

# Disable ipv6 via sysctl - this needs dracut -f if it breaks rpcbind
# TODO: move disabling ipv6 to kickstart
sysctl { 'net.ipv6.conf.all.disable_ipv6':
  value => '1' }

# mod 'puppetlabs-firewall', '1.9.0'
class { 'firewall':
  ensure => 'stopped',
}

# mod 'saz-sudo', '4.2.0'
class { 'sudo': }
sudo::conf { 'systems':
  priority =>   10,
  source   =>   'puppet:///files/sudo/systems.conf',
}

# mod 'yuav-autofs', '1.2.4'
class { 'autofs':
  mount_files => {
    net_data  => {
      mountpoint  => '/net',
      file_source => 'puppet:///files/autofs/auto.net.data',
    },
    job_data  => {
      mountpoint  => '/job',
      file_source => 'puppet:///files/autofs/auto.job.data',
    }
  }
}
