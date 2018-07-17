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
      'password_secret' => '...',    # Fill in your password secret
      'root_password_sha2' => '...', # Fill in your root password hash
     }
  }
}
