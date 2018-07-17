# profile included in base role
# requires vcsrepo from the forge
class profile::accounts {

  group { 'puppet':
    ensure => 'present',
    gid    => '52',
  }

  # create our default local user
  user { 'systems':
    ensure           => 'present',
    home             => '/home/systems',
    managehome       => true,
    password         => '$1$GameForc$5aLg3YmOPfKApjeLWr./5/',
    password_max_age => '99999',
    password_min_age => '0',
    shell            => '/bin/zsh',
    uid              => '502',
    comment          => 'systems',
    groups           => [ 'users','puppet' ]
  }

  # ssh key we created on the puppet master during the install
  file { '/root/.ssh/id_rsa.pub':
    ensure  =>  'present',
    owner   =>  'root',
    group   =>  '0',
    mode    =>  '0600',
    source  =>  'puppet:///files/ssh/id_rsa.pub'
  }

  ssh_authorized_key { 'r10k@owi.lan':
    ensure =>  present,
    user   =>  'root',
    type   =>  'ssh-rsa',
    key    =>  'AAAAB3NzaC1yc2EAAAADAQABAAABAQDQJtxyjVtzJ6Nuulm86e17kRfvclYsZhzpfi/UtBpicDJaZAgeC0LWZC7/x/vOLkA256QbxaNouQTblWLzel7lJqaq2iZ6o08e2vFGf1t9Pw69bBZN4pBXnHvyKKECjdSmatnaYQCOfB2QiPsm0RsU72yIBpBKW7/a/Yw7ecuwvlpNXrDJ5l78DjCt1g+f8W3eW/caOW+4XhmeIm+mV66F0PZz4Zddxeu4aByqJ+hs11VSt3jEjh9B/FuMPsH1Wae2+8nMAeZVl5oN7/X3hy96QaAFh3e/x22TdUqHHbCBWZWOhyftrfITOH7SY8HmcHFFjVhhPG3PIxqosN6XUQlD',
    name   =>  'r10k@site',
  }
  # Setup symlinks to dotfiles
  file { '/home/systems/.zshrc':
    ensure => 'symlink',
    target => '/home/systems/.dotfiles/zshrc.linux',
  }

  file { '/home/systems/.vimrc':
    ensure => 'symlink',
    target => '/home/systems/.dotfiles/vimrc',
  }

  file { '/home/systems/.vim':
    ensure => 'symlink',
    target => '/home/systems/.dotfiles/vim',
  }

  file { '/home/systems/.gitconfig':
    ensure => 'symlink',
    target => '/home/systems/.dotfiles/gitconfig',
  }

  file { '/home/systems/.screenrc':
    ensure => 'symlink',
    target => '/home/systems/.dotfiles/screenrc',
  }
}
