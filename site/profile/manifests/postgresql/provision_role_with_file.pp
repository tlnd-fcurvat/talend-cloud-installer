#
# Provisions server with sql file
#
define profile::postgresql::provision_role_with_file (

  $role_name = undef,

) {

  $role      = $profile::postgresql::roles[$role_name]
  $file      = $name
  $file_safe = regsubst($file, '[^0-9a-zA-Z]', '_', 'G')
  $creates   = "/var/tmp/${file_safe}.done"

  $host   = $profile::postgresql::hostname
  $user   = $role_name
  $pass   = pick($role['password'], $profile::postgresql::password)
  $dbname = $role_name

  exec { "provision ${role_name} with ${file} : exec":
    environment => "PGPASSWORD=${pass}",
    command     => "/usr/bin/psql -U ${user} -h ${host} -d ${dbname} -f ${file} && touch ${creates}",
    creates     => $creates
  }

}
