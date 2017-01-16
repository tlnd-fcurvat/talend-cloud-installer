class profile::mongodb::roles (

  $db_address = 'admin',
  $roles      = {},

) {

  if $profile::mongodb::service_ensure == 'running' {
    create_resources('profile::mongodb::role', $roles)
  }

}
