node default {# node default opening brace
  # Set ntp server
  class { '::ntp':
    servers => [ 'clock.stellarcreativ.lab' ],
    }
  
  # Disable ipv6 via sysctl
  sysctl { 'net.ipv6.conf.all.disable_ipv6': 
    value => '1' }

}# node default closing brace
