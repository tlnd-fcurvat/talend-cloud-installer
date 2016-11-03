#
# Sets up the mongodb instance
#
class profile::mongodb(
  $shared_key = undef
) {

  require ::profile::common::packages

  include ::profile::common::concat

  profile::register_profile { 'mongodb': }

  $_mongo_nodes = parsejson($::mongodb_nodes)

  # explicitly only support replica sets of size 3
  if size($_mongo_nodes)  == '3' {
    $_mongo_members = suffix($_mongo_nodes, ':27017')

    $replset_name = 'tipaas'

    $replset_config = {
      'tipaas' => {
        ensure  => 'present',
        members => $_mongo_members
      }
    }

    if $shared_key {
      $mongo_auth = true
      $keyfile = '/var/lib/mongo/shared_key'
    } else {
      $mongo_auth = false
      $keyfile = undef
    }

  } else {
    $mongo_replset_name = undef
    $replset_name = undef
    $mongo_auth = true
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
    verbose        => true,
    auth           => $mongo_auth,
    bind_ip        => [$::ipaddress, '127.0.0.1'],
    replset        => $replset_name,
    replset_config => $replset_config,
    key            => $shared_key,
    keyfile        => $keyfile
  } ->
  class { '::mongodb::client':
  }

  if $::cfn_resource_name == 'InstanceA' {

    Anchor['::mongodb::client::end'] ->

    exec { 'setup MongoDB admin user':
      command => $create_admin_user,
      creates => '/var/lock/mongo_admin_user_lock',
    }
  }

  contain ::mongodb::server
  contain ::mongodb::client

}

