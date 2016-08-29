#
# Provisions server with sql files
#
define profile::postgresql::provision_role {

  $role = $profile::postgresql::roles[$name]

  $files = pick($role['files'], [])
  profile::postgresql::provision_role_with_file { $files:
    role_name => $name,
  }

}
