class profile::repo {

  class { 'apache':
  default_vhost => false,
  }

  # Ensure the vhosts directory structure exists
  file { '/var/www/html/vhosts':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # ks directory for kickstart configs
  file { '/var/www/html/vhosts/repo/ks':
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
