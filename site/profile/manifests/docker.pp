# Installs docker
class profile::docker {
  include 'docker'

  docker::run { 'sickrage':
  image   => 'sickrage:sickrage',
  command => '',
  volumes => ['config:/opt/sickrage/config'],
  volumes => ['downloads:/net/systems/downloads'],
  volumes => ['series:/net/series'],
  volumes => ['localtime:/etc/localtime:ro'],
  ports   => ['8081', '8081'],
  }
}
