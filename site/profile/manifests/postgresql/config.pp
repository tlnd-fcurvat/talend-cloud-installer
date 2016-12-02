class profile::postgresql::config {

  require ::profile::postgresql::install

  if $profile::postgresql::service_ensure == 'running' {
    $role_names = keys($profile::postgresql::roles)
    profile::postgresql::role { $role_names: }
  }

}
