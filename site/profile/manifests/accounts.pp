# requires vcsrepo from the forge
class profile::accounts {

  group { 'puppet':
    ensure => 'present',
    gid    => '52',
  }

  # create our default local user
  user { 'systems':
    ensure           => 'present',
    home             => '/home/systems',
    managehome       => 'true',
    # Generate password with openssl passwd -1
    password         => '$1$VVrr57Wd$2gyRbqpQubfMfF1FCKUxf1',
    password_max_age => '99999',
    password_min_age => '0',
    shell            => '/bin/bash',
    uid              => '502',
    comment          => 'systems',
    groups           => [ 'users','puppet' ]
  }
}
