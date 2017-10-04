class profile::linux {
  include profile::mounts
  include ::openvmtools

  # setup environment
  $stellarpath = '/net/software/bin:/usr/lib64/qt-3.3/bin:/opt/puppetlabs/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:${PATH}'
  file { "/etc/profile.d/stellar.sh":
    content => "export PATH=${stellarpath}",
    mode    => '0644'
  }

  # mod 'saz-motd', '2.4.0'
  class { 'motd': }

  # mod 'puppetlabs-ntp', '6.2.0'
  class { '::ntp':
    servers => [ 'clock.stellarcreative.lab' ],
  }

  # Disable ipv6 via sysctl - this needs dracut -f if it breaks rpcbind
  # TODO: move disabling ipv6 to kickstart
  sysctl { 'net.ipv6.conf.all.disable_ipv6':
    value => '1' }

  # mod 'puppetlabs-firewall', '1.9.0'
  class { 'firewall':
    ensure => 'stopped',
  }

  # mod 'saz-sudo', '4.2.0'
  class { 'sudo': }
  sudo::conf { 'systems':
    priority =>   10,
    source   =>   'puppet:///files/sudo/systems.conf',
  }

  class {'::adcli':
    ad_domain        => 'stellarcreative.lab',
    ad_join_username => 'systems',
    ad_join_password => '#thx1138',
    ad_join_ou       => 'cn=computers,dc=stellarcreative,dc=lab'
  } 

  # sssd class
  class {'::sssd':
  config => {
    'sssd' => {
      'domains'             => 'stellarcreative.lab',
      'config_file_version' => 2,
      'services'            => ['nss', 'pam'],
    },
    'domain/ad.example.com' => {
      'ad_domain'                      => 'stellarcreative.lab',
      'ad_server'                      => ['ads1.stellarcreative.lab'],
      'krb5_realm'                     => 'STELLARCREATIVE.LAB',
      'realmd_tags'                    => 'joined-with-samba',
      'cache_credentials'              => true,
      'id_provider'                    => 'ad',
      'krb5_store_password_if_offline' => true,
      'default_shell'                  => '/bin/bash',
      'ldap_id_mapping'                => false,
      'use_fully_qualified_names'      => false,
      'fallback_homedir'               => '/net/home/%u',
      'access_provider'                => 'simple',
      'simple_allow_groups'            => ['domain admins', 'users', 'systems'],
      }
    }
  }
}
