class profile::puppet {

  # Configure puppetdb and its underlying database
  class { 'puppetdb':
    listen_address =>  '0.0.0.0',
  }

  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }

  # r10k setup
  class { 'r10k':
    # change this to your actual puppet control repo
    remote => 'git@github.com:gameforce/puppet-site.git',
  }

  sshkey { "r10k@site":
    ensure   => present,
    type     => "ssh-rsa",
    target   => "/root/.ssh/known_hosts",
    key      => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQJtxyjVtzJ6Nuulm86e17kRfvclYsZhzpfi/UtBpicDJaZAgeC0LWZC7/x/vOLkA256QbxaNouQTblWLzel7lJqaq2iZ6o08e2vFGf1t9Pw69bBZN4pBXnHvyKKECjdSmatnaYQCOfB2QiPsm0RsU72yIBpBKW7/a/Yw7ecuwvlpNXrDJ5l78DjCt1g+f8W3eW/caOW+4XhmeIm+mV66F0PZz4Zddxeu4aByqJ+hs11VSt3jEjh9B/FuMPsH1Wae2+8nMAeZVl5oN7/X3hy96QaAFh3e/x22TdUqHHbCBWZWOhyftrfITOH7SY8HmcHFFjVhhPG3PIxqosN6XUQlD root@puppet"
  }

  class { '::r10k::webhook::config':
    default_branch   => 'production',
    use_mcollective  => false,
    public_key_path  => "/etc/puppetlabs/puppet/ssl/ca/signed/${facts['fqdn']}.pem",
    private_key_path => "/etc/puppetlabs/puppet/ssl/private_keys/${facts['fqdn']}.pem",
  }

  class { '::r10k::webhook':
    user    => 'puppet',
    group   => 'puppet',
  }
}
