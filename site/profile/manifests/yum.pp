class profile::yum {

include 'yum'

yum::config { 'exclude':
  ensure => 'kernel.*',
}

#yum::versionlock { '0:kernel-3.10.0-693.5.2.el7.*':
#  ensure => present,
#  }

}
