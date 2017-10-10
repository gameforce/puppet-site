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
    managehome       => 'true',
    # Generate password with openssl passwd -1
    password         => '$1$VVrr57Wd$2gyRbqpQubfMfF1FCKUxf1',
    password_max_age => '99999',
    password_min_age => '0',
    shell            => '/bin/bash',
    uid              => '502',
    comment          => 'systems',
    groups           => [ 'users','puppet' ]
  }

#  ssh_authorized_key { 'r10k@stellar': 
#    user             =>  'root',
#    ensure           =>  present, 
#    type             =>  'ssh-rsa', 
#    key              =>  'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6WN9RbxpLn9oa3IArG6MVT4F7BySNyjKp10itqC38qqNkeEYy8oAHjHh56ErnmrONZ1OomKALaRblJypRo8jBqcULsn3B4R0NW37vMLCyCulk/YasyMiDtU+yE74gkIbTUkbV2Q8t2PHgq69aqKVs2cgXC3znvd93yjqSJEgUjQjzWDiHifs/BTWEFWFSQ1VpQoaKlRueN0048pXC3u6QDldmo82bJunW6FSkq7fkim+ADSOpT/ptxO0AkEetgflvB1cSh1Ar+eyOU0ljljBLp0D4ltjL2UU1HnwXn7o1CRW0JEyz/51PFK6OnwcgocGzmay3b5qd6Y6oPHznqCUp r10k@stellar', 
#    name             =>  'r10k@stellar',
#  }

  # clone the dotfiles repo
  vcsrepo { '/home/systems/.dotfiles':
    ensure => 'latest',
    provider => 'git',
    owner => 'systems',
    group => 'users',
    source => 'git@git:systems/dotfiles.git',
    revision => 'master',
  }

# Setup symlinks to dotfiles
  file { '/home/systems/.bashrc':
    ensure => 'symlink',
    target => '/home/systems/.dotfiles/bashrc',
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
