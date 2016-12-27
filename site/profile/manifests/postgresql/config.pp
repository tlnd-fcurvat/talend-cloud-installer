class profile::postgresql::config {

  require ::profile::postgresql::install

  if str2bool($profile::postgresql::create_databases) == true {
    $role_names = keys($profile::postgresql::roles)
    profile::postgresql::role { $role_names: }
  }

}
