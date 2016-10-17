#
# Installs hiera-defined accounts and settings
#
class profile::common::accounts {
  require ::user_accounts
  require ::sudo
}

