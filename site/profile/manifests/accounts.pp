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

  ssh_authorized_key { r'root-ssh-key': 
    user             =>  r'root',
    ensure           =>  present, 
    type             =>  'ssh-rsa', 
    key              =>  'AAAAB3NzaC1yc2EAAAADAQABAAABAQDqageI88+KLEhXje9/37k+VwO4jfNTd4ZRbnvucLdO8WRYVmGe5sV1X8hf76Ur9KOyQfSwFq6RUzhXDKcC2y0t2I/YbLFnHKIMtZH9MfRC6cfAhJHgQx6PP6SXdbExvrxTcc4enzA3oYE5+jQcM2hEsDGGT8Zf2BulYIYY2YGfihVq5tHvD1fg5A3nVWVNFxwVq7dcVF5M5UGfNqXFB+bbUtyRtZwyXFayW1Ea61K4V9lu6PiUl64Melb2T6kfH+6Qu9411YiV0IM6oDgdZB0v8ekFAA95FLJ956G2Zu+67LUq4xxfNJhT0BlaiPdUkYfD6SI6+ics/3pgmQABwwS5', 
    name             =>  'root-ssh-key',
  }

   ssh_authorized_key { "systems-ssh-key":
    user             =>  "systems",
    ensure           =>  present, 
    type             =>  "ssh-rsa",
    key              =>  "AAAAB3NzaC1yc2EAAAADAQABAAABAQCYGq9HK49vF8b9fzygkibjV8VDYBsGfq1y1IwueQGee3oAKMMQ/jNCvTAq3GWosXCjz6hXfFrUyJFnL3boHBAGJqOJ1u/o0yierrxX/GJT2RGCoVXQjT/wiDVA9D3RGPisf4A8ThwL7I5DPYQSNqusY+7AGElfkdYKP5q7jqNwJO+DmfeatzKQfGS99dF7JhLf5lnon43GG5jCEjceU22VRVu3ZuRmBLgS+i/xrLQ9UC4b97VZLfYjsHW4b0wU3UxMkrH1muTOFrfFKEoaJqnf08f+eMwbz8GIUzHZHED8Nb8OQHmMvAnT40QCnOphE80DAUOk2Fam6ALVEkbFGy6/",
    name             =>  "systems-ssh-key",
  } 

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
