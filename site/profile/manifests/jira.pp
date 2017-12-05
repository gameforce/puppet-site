# mod 'puppet-nginx', '0.9.0'

class profile::jira {
  include postgresql::server

    postgresql::database_user{'jiraadm':
    password_hash => 'mypassword',
  }


  class { 'jira':
    javahome    => '/usr',
    deploy_module => 'archive',
  }
}
