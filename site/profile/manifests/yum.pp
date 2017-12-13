class profile::yum {

#include 'yum'

class { 'yum':
  managed_repos =>  'stellar',
}

  managed_repos { 'stellar':
    ensure    => 'present',
    enabled   => 'true',
    descr     => 'Stellar Repo',
    baseurl   => 'http://repo/stellar/x86_64/',
    gpgcheck  => false,
    target    => '/etc/yum.repos.d/stellar.repo'
  }
}
