class profile::postgresql::config {

  require ::profile::postgresql::install

  $role_names = keys($profile::postgresql::roles)
  profile::postgresql::role { $role_names: }

}
