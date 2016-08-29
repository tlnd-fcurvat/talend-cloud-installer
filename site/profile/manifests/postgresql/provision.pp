class profile::postgresql::provision {

  require ::profile::postgresql::config

  $role_names = keys($profile::postgresql::roles)
  profile::postgresql::provision_role { $role_names: }

}
