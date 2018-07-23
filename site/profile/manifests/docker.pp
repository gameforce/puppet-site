# Installs docker
class profile::docker {
  include 'docker'

  docker::registry { 'registry-1.docker.io:5000':
  username => 'darf',
  password => '!mtFbwy77-docker',
}

  docker::run { 'sickrage':
  image   => 'sickrage:sickrage',
  command => '',
  volumes => ['config:/opt/sickrage/config', 'downloads:/net/systems/downloads', 'series:/net/series', 'localtime:/etc/localtime:ro',],
  ports   => ['8081', '8081'],
  }
}
