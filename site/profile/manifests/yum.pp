class profile::yum {

#include 'yum'

class { 'yum':
  managed_repos =>  [ 'stellar' ],
}

yum::versionlock { '0:bash-4.1.2-9.el6_2.*':
  ensure => present,
}


  yum::repos { 'stellar':
    ensure    => 'present',
    enabled   => 'true',
    descr     => 'Stellar Repo',
    baseurl   => 'http://repo/stellar/x86_64/',
    gpgcheck  => false,
    target    => '/etc/yum.repos.d/stellar.repo'
  }
}
