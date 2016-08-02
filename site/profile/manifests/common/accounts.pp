#
# Installs hiera-defined accounts and settings
#
class profile::common::accounts {
  require ::accounts
  require ::sudo
}

