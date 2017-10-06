class role::base {
  include profile::base
  include profile::packages
  include profile::accounts
  include profile::autofs
}
