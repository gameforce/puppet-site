node default {
  # mod 'razorsedge-openvmtools', '1.1.0'
  include ::openvmtools
  include ::motd

  # Set ntp server
  class { '::ntp':
    servers => [ 'clock.stellarcreativ.lab' ],
    }
  
  # Disable ipv6 via sysctl - this needs dracut -f if it breaks rpcbind
  sysctl { 'net.ipv6.conf.all.disable_ipv6': 
    value => '1' }

  # requires saz-sudo from the forge
  class { 'sudo': }
  sudo::conf { 'systems':
    priority =>   10,
    source =>   'puppet:///files/sudo/systems.conf',
  }

}

node kam1.stellarcreative.lab {
  # Configure puppetdb and its underlying database
  class { 'puppetdb': }

  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }
}

node box49.stellarcreative.lab {
}
