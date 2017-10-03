# mod 'puppet-autofs', '4.0.0'
#autofs::mount { 'net':
#  mount       => '/net',
#  mapfile     => '/etc/auto.net',
#  mapcontents => ['* -user,rw,soft,intr,rsize=32768,wsize=32768,tcp,nfsvers=3,noacl srv1:/data/net'],
#  options     => '--timeout=300',
#  order       => 01
#}

autofs::mount { 'job':
  mount       => '/job',
  mapfile     => '/etc/auto.job',
  mapcontents => ['* -user,rw,soft,intr,rsize=32768,wsize=32768,tcp,nfsvers=3,noacl srv1:/data/job'],
  options     => '--timeout=300',
  order       => 02
}

