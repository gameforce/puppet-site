class profile::graylog {

  include ::java

  class { 'mongodb::globals':
     manage_package_repo => true,
  }->
  class { 'mongodb::server':
     bind_ip => ['127.0.0.1'],
  }
  # requires mod 'elastic-elastic_stack', '6.2.0'
  class { 'elastic_stack::repo':
  version => 5,
 }
 class { 'elasticsearch':
   version      => '5.5.1',
 }

elasticsearch::instance { 'graylog':
  config => {
    'cluster.name' => 'graylog',
    'network.host' => '127.0.0.1',
  }
}

#elasticsearch::user { 'esuser':
#  password         => 'espass0',
#  roles            => ['admin'],
#}

  class { 'graylog::repository':
    version => '2.4'
  }->
  class { 'graylog::server':
    package_version => '2.4.0-9',
    config          => {
      'password_secret' => 'glpass0',    # Fill in your password secret
      'root_password_sha2' => '78A8FEE4F288990B5D0C27DDB5B6D36B5937E2ABFE11F2F6BCE99052F4DAB89C', # Fill in your root password hash
     }
  }
}
