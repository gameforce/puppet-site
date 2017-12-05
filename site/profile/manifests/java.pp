# mod 'puppet-nginx', '0.9.0'

class profile::java {
  class { 'java':
    distribution      => 'jre',
    java_default_home => '/opt/java',
  }
}
