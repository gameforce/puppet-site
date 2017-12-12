class profile::yum {

include 'yum'

  managed_repos { 'stellar':
    ensure    => 'present',
    enabled   => 'true',
    descr     => 'Stellar Repo'
    baseurl   => 'http://repo/stellar/$basesearch/'
    gpgcheck  => false
    target    => '/etc/yum.repos.d/stellar.repo'
  }
