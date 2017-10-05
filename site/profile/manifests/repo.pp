class profile::repo {
  # kickstart setup
  file { '/var/www/html/vhosts/repo/ks/centos-desktop.ks':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///files/kickstart/centos-desktop.ks',
    notify =>  Service['httpd'],

  }

  file { '/var/www/html/vhosts/repo/ks/centos-server.ks':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///files/kickstart/centos-server.ks',
    notify =>  Service['httpd'],
  }

  file { '/var/www/html/vhosts/repo/ks/centos-virtualbox.ks':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///files/kickstart/centos-virtualbox.ks',
    notify =>  Service['httpd'],
  }

  class { 'apache':
  default_vhost => false,
  }

  # Ensure the vhosts directory exists
  file { '/var/www/html/vhosts':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # vhost definitions
  apache::vhost { 'repo':
  port    => '80',
  docroot => '/var/www/html/vhosts/repo',
  }
}
