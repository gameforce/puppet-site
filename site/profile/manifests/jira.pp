# mod 'puppet-nginx', '0.9.0'

class profile::jira {
  include postgresql::server
  include postgresql::role
  postgresql::role {'jiraadm':
    password_hash => '34819d7beeabb9260a5c854bc85b3e44',
    createdb => 'true',
  }


  class { 'jira':
    javahome    => '/usr',
    deploy_module => 'archive',
  }
}
