# mod 'puppet-nginx', '0.9.0'

class profile::jira {
  class { 'jira':
    javahome    => '/opt/java',
    deploy_module => 'archive',
  }
}
