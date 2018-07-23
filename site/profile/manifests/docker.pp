# Installs docker
class profile::docker {
  include 'docker'

  docker::run { 'sickrage':
  image   => 'sickrage:sickrage',
  command => '',
  volumes => ['config:/opt/sickrage/config', 'downloads:/net/systems/downloads', 'series:/net/series', 'localtime:/etc/localtime:ro',],
  ports   => ['8081', '8081'],
  }
}
