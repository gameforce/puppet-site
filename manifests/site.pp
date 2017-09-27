node default {
  # Set ntp server
  class { '::ntp':
    servers => [ 'clock.stellarcreativ.lab' ],
    }
  
  # Disable ipv6 via sysctl - this needs dracut -f if it breaks rpcbind
  sysctl { 'net.ipv6.conf.all.disable_ipv6': 
    value => '1' }

}

node kam1.stellarcreative.lab {
  # Configure puppetdb and its underlying database
  class { 'puppetdb': }

  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }
}

node box49.stellarcreative.lab {
  # requires saz-sudo from the forge
    class sudo {

    sudo::conf { 'systems':
        priority =>  10,
        source =>  'puppet:///files/sudo/systems.conf',

       }
   }
}
