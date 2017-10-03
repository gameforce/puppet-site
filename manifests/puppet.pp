class puppet {
  # mod 'puppetlabs-puppetdb', '6.0.1'
  # Configure puppetdb and its underlying database
  class { 'puppetdb': }

  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }

  # r10k setup
  class { 'r10k':
    remote => 'git@git:systems/puppet.git',
  }

  sshkey { "kam1.stellarcreative.lab":
    ensure   => present,
    type     => "ssh-rsa",
    target   => "/root/.ssh/known_hosts",
    key      => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDqageI88+KLEhXje9/37k+VwO4jfNTd4ZRbnvucLdO8WRYVmGe5sV1X8hf76Ur9KOyQfSwFq6RUzhXDKcC2y0t2I/YbLFnHKIMtZH9MfRC6cfAhJHgQx6PP6SXdbExvrxTcc4enzA3oYE5+jQcM2hEsDGGT8Zf2BulYIYY2YGfihVq5tHvD1fg5A3nVWVNFxwVq7dcVF5M5UGfNqXFB+bbUtyRtZwyXFayW1Ea61K4V9lu6PiUl64Melb2T6kfH+6Qu9411YiV0IM6oDgdZB0v8ekFAA95FLJ956G2Zu+67LUq4xxfNJhT0BlaiPdUkYfD6SI6+ics/3pgmQABwwS5 r10k@kam1"
  }

  class { '::r10k::webhook::config':
#    protected        => false,
    use_mcollective => false,
    public_key_path  => "/etc/puppetlabs/puppet/ssl/ca/signed/${facts['fqdn']}.pem",
    private_key_path => "/etc/puppetlabs/puppet/ssl/private_keys/${facts['fqdn']}.pem",
#    notify           => Service['webhook'],
  }

  class { '::r10k::webhook':
    user    => 'root',
    group   => 'root',
#    require => Class['::r10k::webhook::config'],
  }
}

