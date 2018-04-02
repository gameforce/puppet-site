class profile::samba {
  
  class {'samba::server':
    workgroup     => 'domain.local',
    server_string => "Site Samba Server",
    interfaces    => "eth0 lo",
    security      => 'share'
  }

  samba::server::share {'home':
    comment              => 'Home Directories',
    path                 => '/net/homes',
    guest_only           => false,
    guest_ok             => false,
    guest_account        => "none",
    browsable            => false,
    create_mask          => 0644,
    directory_mask       => 0755,
    force_group          => 'domain users',
  }
}
