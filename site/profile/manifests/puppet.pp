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

  sshkey { "r10k@stellar":
    ensure   => present,
    type     => "ssh-rsa",
    target   => "/root/.ssh/known_hosts",
    key      => "AAAAB3NzaC1yc2EAAAADAQABAAABAQC6WN9RbxpLn9oa3IArG6MVT4F7BySNyjKp10itqC38qqNkeEYy8oAHjHh56ErnmrONZ1OomKALaRblJypRo8jBqcULsn3B4R0NW37vMLCyCulk/YasyMiDtU+yE74gkIbTUkbV2Q8t2PHgq69aqKVs2cgXC3znvd93yjqSJEgUjQjzWDiHifs/BTWEFWFSQ1VpQoaKlRueN0048pXC3u6QDldmo82bJunW6FSkq7fkim+ADSOpT/ptxO0AkEetgflvB1cSh1Ar+eyOU0ljljBLp0D4ltjL2UU1HnwXn7o1CRW0JEyz/51PFK6OnwcgocGzmay3b5qd6Y6oPHznqCUp"
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
