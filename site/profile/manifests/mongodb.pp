#
# Sets up the mongodb instance
#
class profile::mongodb {

  require ::profile::common::packages

  include ::profile::common::concat

  profile::register_profile { 'mongodb': }

  $create_admin_user = "/usr/bin/mongo ipaas --eval \"db.createUser({ \
    user: 'admin', \
    pwd: '${::master_password}', \
    roles: [ \
      {role: 'userAdminAnyDatabase', db: 'admin'}, \
      {role: 'dbAdminAnyDatabase', db: 'admin'}, \
      {role: 'readWriteAnyDatabase', db: 'admin'}, \
      {role: 'dbOwner', db: 'ipaas'} \
    ] \
});\" && /bin/touch /var/lock/mongo_admin_user_lock"

  class {'::mongodb::globals':
    manage_package_repo => true,
  }->
  class { '::mongodb::server':
    verbose => true,
    auth    => true,
    bind_ip => [$::ipaddress, '127.0.0.1'],
  } ->
  class { '::mongodb::client':
  } ->
  exec { 'setup MongoDB admin user':
    command => $create_admin_user,
    creates => '/var/lock/mongo_admin_user_lock',
  }

  contain ::mongodb::server
  contain ::mongodb::client

}
