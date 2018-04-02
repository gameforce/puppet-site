class profile::puppet {
  
  # Configure puppetdb and its underlying database
  class { 'puppetdb': 
    listen_address =>  '0.0.0.0',
  }

  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }

  # r10k setup
  class { 'r10k':
    remote => 'git@git:systems/puppet.git',
  }

  sshkey { "r10k@site":
    ensure   => present,
    type     => "ssh-rsa",
    target   => "/root/.ssh/known_hosts",
    key      => "<key"
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
