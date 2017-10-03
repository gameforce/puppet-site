node default {
  include common
  }

node kam1.stellarcreative.lab {
  # mod 'puppetlabs-puppetdb', '6.0.1'
  # Configure puppetdb and its underlying database
  class { 'puppetdb': }

  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }
  }

node box49.stellarcreative.lab {
  #  includes
}
