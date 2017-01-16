class profile::mongodb::users (

  $db_address = 'admin',
  $users      = {},

) {

  if $profile::mongodb::service_ensure == 'running' {
    create_resources('profile::mongodb::user', $users)
  }

}
