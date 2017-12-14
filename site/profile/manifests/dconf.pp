# Configure dconf defaults for gnome3
class profile::dconf {

  #notify {"NEW: testing new bits":}
  class { 'gnome3':
    button_power     => $gnome3::params::button_power,
    background       => undef, #/usr/share/backgrounds/smile-wallpaper.jpg
    screensaver_lock => true,
    bookmarks        => undef,
    software         => undef,
    games            => $gnome3::params::games,
    delete_games     => true,
    gdm              => '',
    webproxy_mode    => $gnome3::params::webproxy_mode,
    webproxy_autourl => '',
    webproxy_locked  => true,
  }
}
