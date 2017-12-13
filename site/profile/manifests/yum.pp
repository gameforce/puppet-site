class profile::yum {

#include 'yum'

  class { 'yum':
    managed_repos =>  [ 'stellar' ],
   }

   yum::versionlock { '0:bash-4.1.2-9.el6_2.*':
     ensure       => present,
   }
}
