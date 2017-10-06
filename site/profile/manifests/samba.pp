class profile::samba {
  
  class {'samba::server':
    workgroup     => 'stellarcreative.lab',
    server_string => "Samba Server on srv1",
    interfaces    => "eth0 lo",
    security      => 'share'
  }

  samba::server::share {'home':
    comment              => 'Home Directories',
    path                 => '/data/net/home',
    guest_only           => false,
    guest_ok             => false,
    guest_account        => "none",
    browsable            => false,
    create_mask          => 0644,
    directory_mask       => 0755,
    force_group          => 'domain users',
  }
}
