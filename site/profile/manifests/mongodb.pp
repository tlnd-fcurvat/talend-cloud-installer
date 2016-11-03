#
# Sets up the mongodb instance
#
class profile::mongodb {

  require ::profile::common::packages

  include ::profile::common::concat

  profile::register_profile { 'mongodb': }

  $_mongo_nodes = parsejson($::mongodb_nodes)

  # explicitly only support replica sets of size 3
  if size($_mongo_nodes)  == '3' {
    $_mongo_members = suffix($_mongo_nodes, ':27017')

    $mongo_replset_name = 'tipaas'

    mongodb_replset { 'tipaas':
      ensure  => present,
      members => $_mongo_members,
      before  => Exec['setup MongoDB admin user']
    }
  } else {
    $mongo_replset_name = undef
  }


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
    replset => $mongo_replset_name
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
