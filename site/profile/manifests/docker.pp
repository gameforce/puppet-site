# Installs docker
class profile::docker {
  include 'docker'

  docker::registry {'https://index.docker.io/v1/':
  username => 'darf',
  password => '!mtFbwy77-docker',
}

  docker::run { 'sickrage':
  image   => 'sickrage',
  image_tag => 'sickrage'
  detach  => true,
  command => '',
  volumes => ['config:/opt/sickrage/config', 'downloads:/net/systems/downloads', 'series:/net/series', 'localtime:/etc/localtime:ro',],
  ports   => ['8081'],
  }
}
