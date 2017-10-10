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

  file { '/home/systems/.ssh/id_rsa':
    ensure          =>  'present',
    owner           =>  'systems',
    group           =>  'users',
    mode            =>  '0644',
    source          =>  'puppet:///files/ssh/id_rsa',
  }

  ssh_authorized_key { 'systems@stellar': 
    user             =>  'systems',
    ensure           =>  present, 
    type             =>  'ssh-rsa', 
    key              =>  'AAAAB3NzaC1yc2EAAAADAQABAAABAQDXA3azLpA7ZBtfud+iul+h8iP2f2TcFYIWZn4/z8ofIT8ikmyElA0eTrpo2lE+ykv62lywiM3O/b3QUDMlELhJXXLbglrxX/El9Yw9KQjz0P5KgmAiCuUKCntqdUDSDLPb24spUR2zG/oUgah0SY2DZqS9vTi9iDKKV/CWEtRHakLiydB8OqBX58834PwV348COMk9/CC2kMWHFYUHjIqx5vr3GsxXbTBIlr5KeWZ9iQeYa4UrlHn4FZ1o8FWKucOFFhtGaTyQ9r+USZ4AgswelYjSeGLizHkM0zrtJdboq9F+gofGF3DOxq7Jk+bxJ4yhrrhNfU1ygzkjdLVQshzd',
    name             =>  'systems@stellar',
  }

  # clone the dotfiles repo
  vcsrepo { '/home/systems/.dotfiles':
    ensure => 'latest',
    provider => 'git',
    owner => 'systems',
    group => 'users',
    user  =>  'systems',
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
