
class role::base {
  include profile::base
  include profile::accounts
  include profile::packages
  include profile::autofs
  include profile::yum
}
