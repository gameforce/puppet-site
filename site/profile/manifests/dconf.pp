# Configure dconf defaults for gnome3
class profile::dconf {

  #notify {"NEW: testing new bits":}
  class { 'gnome3':
    button\_power    => $gnome3::params::button_power,
    background       => undef, #/usr/share/backgrounds/smile-wallpaper.jpg
    screensaver_lock => true,
    bookmarks        => undef,
    software         => undef,
    games            => $gnome3::params::games,
    delete\_games    => true,
    webproxy\_mode   => $gnome3::params::webproxy_mode,
    webproxy\_autourl=> '',
    webproxy\_locked => true,
  }
}
