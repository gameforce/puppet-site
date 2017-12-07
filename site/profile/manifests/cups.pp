# mod 'leoarnold-cups', '2.0.2'
class profile::cups {

include '::cups'

  cups_queue { 'WF-3720':
    ensure => 'printer',
    ppd    => '/usr/share/cups/model/WF-3720.ppd',
    uri    => 'lpd://172.16.21.37:515/PASSTHRU'
  }

  file { '/usr/share/cups/model/WF-3720.ppd':
    ensure => 'file',
    source => 'puppet:///files/cups/WF-3720.ppd'
  }
}
