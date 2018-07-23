# Installs docker
class profile::docker {
  include 'docker'

  docker::registry {'https://index.docker.io/v1/':
  username => 'darf',
  password => '!mtFbwy77-docker',
}

docker::run {'sickrage':
  image   => 'linuxserver/sickrage',
  detach  => true,
  env     => ['PGID=1000', 'PUID=502', 'TZ=America/Vancouver', ],
  volumes => ['/opt/sickrage/config:/config', '/tmp/downloads:/downloads', '/tmp/tv:/tv', ],
  ports   => ['8082:8082'],
  }
}
