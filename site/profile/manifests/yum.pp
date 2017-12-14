class profile::yum {

include 'yum'

yum::versionlock { '0:kernel-3.10.0-693.5.2.el7.*':
  ensure => present,
  }

yum::versionlock { '0:kmod-wacom-0.37.1-1.el7_4.*':
  ensure => present,
  }
}