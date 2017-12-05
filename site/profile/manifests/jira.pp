# mod 'puppet-nginx', '0.9.0'

class profile::jira {
  class { 'jira':
    javahome    => '/usr',
    deploy_module => 'archive',
  }
}
