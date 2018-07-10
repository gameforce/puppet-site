# mod 'leoarnold-cups', '2.0.2'
class profile::cups {

include '::cups'

  cups_queue { 'WF-3720':
    ensure    => 'printer',
    enabled   => 'true',
    accepting => 'true',
    ppd       => '/usr/share/cups/model/WF-3720.ppd',
    uri       => 'lpd://<IP of printer>:515/PASSTHRU'
  }

  file { '/usr/share/cups/model/WF-3720.ppd':
    ensure    => 'file',
    source    => 'puppet:///files/cups/WF-3720.ppd'
  }
}
