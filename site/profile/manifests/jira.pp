# mod 'puppet-nginx', '0.9.0'

class profile::jira {
  include postgresql::server

  class { 'jira':
    javahome    => '/usr',
    deploy_module => 'archive',
  }
}
