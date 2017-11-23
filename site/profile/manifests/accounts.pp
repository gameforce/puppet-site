# requires vcsrepo from the forge
class profile::accounts {

  group { 'puppet':
    ensure => 'present',
    gid    => '52',
  }

  # create our default local user
  user { 'systems':
    ensure           => 'absent',

  file { '/root/.ssh/id_rsa':
    ensure          =>  'present',
    owner           =>  'root',
    group           =>  '0',
    mode            =>  '0600',
    source          =>  'puppet:///files/ssh/id_rsa',
  }

  ssh_authorized_key { 'r10k@stellar':
    user             =>  'root',
    ensure           =>  present,
    type             =>  'ssh-rsa',
    key              =>  'AAAAB3NzaC1yc2EAAAADAQABAAABAQC6WN9RbxpLn9oa3IArG6MVT4F7BySNyjKp10itqC38qqNkeEYy8oAHjHh56ErnmrONZ1OomKALaRblJypRo8jBqcULsn3B4R0NW37vMLCyCulk/YasyMiDtU+yE74gkIbTUkbV2Q8t2PHgq69aqKVs2cgXC3znvd93yjqSJEgUjQjzWDiHifs/BTWEFWFSQ1VpQoaKlRueN0048pXC3u6QDldmo82bJunW6FSkq7fkim+ADSOpT/ptxO0AkEetgflvB1cSh1Ar+eyOU0ljljBLp0D4ltjL2UU1HnwXn7o1CRW0JEyz/51PFK6OnwcgocGzmay3b5qd6Y6oPHznqCUp',
    name             =>  'r10k@stellar',
  }
}
