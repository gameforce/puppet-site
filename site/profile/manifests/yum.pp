class profile::yum {

include 'yum'

#class { 'yum':
#  keep_kernel_devel => true,
#  clean_old_kernels => true,
#  exclude => 'kernel*',
#}

yum::config { 'exclude':
  ensure => 'kernel*',
}

#yum::versionlock { '0:kernel-3.10.0-693.5.2.el7.*':
#  ensure => present,
#  }

#yum::versionlock { '0:kmod-wacom-0.37.1-1.el7_4.*':
#  ensure => present,
#  }

#yum::versionlock { '0:kernel-devel-643.10.0-693.11.1.el7.*':
#  ensure => present,
#  }

#yum::versionlock { '0:kernel-headers-643.10.0-693.11.1.el7.*':
#  ensure => present,
#  }

#yum::versionlock { '0:kernel-tools-643.10.0-693.11.1.el7.*':
#  ensure => present,
#  }

#yum::versionlock { '0:kernel-tools-libs-643.10.0-693.11.1.el7.*':
#  ensure => present,
#  }
}
