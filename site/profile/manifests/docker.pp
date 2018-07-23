# Installs docker
class profile::docker {
  include 'docker'

  docker::registry {'https://index.docker.io/v1/':
  username => 'darf',
  password => '!mtFbwy77-docker',
}

  docker::run { 'sickrage':
  image   => 'sickrage/sickrage',
  detach  => true,
  command => '',
  volumes => ['config:/opt/sickrage/config', 'downloads:/tmp/downloads', 'tv:/tmp/tv', '/etc/localtime:/etc/localtime:ro',],
  ports   => ['8082'],
  }
}
