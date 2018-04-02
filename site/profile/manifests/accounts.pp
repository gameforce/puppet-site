# requires vcsrepo from the forge
class profile::accounts {

  group { 'puppet':
    ensure => 'present',
    gid    => '52',
  }

  # create our default local user
  user { 'systems':
    ensure           => 'absent',
  }

  file { '/root/.ssh/id_rsa':
    ensure =>  'present',
    owner  =>  'root',
    group  =>  '0',
    mode   =>  '0600',
    source =>  'puppet:///files/ssh/id_rsa',
  }

  file { '/root/.ssh/id_rsa.pub':
    ensure  =>  'present',
    owner   =>  'root',
    group   =>  '0',
    mode    =>  '0600',
    source  =>  'puppet:///files/ssh/id_rsa.pub'
  }

  ssh_authorized_key { 'r10k@site':
    ensure =>  present,
    user   =>  'root',
    type   =>  'ssh-rsa',
    key    =>  '<key>',
    name   =>  'r10k@site',
  }
}
