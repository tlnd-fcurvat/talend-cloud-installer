#
# Sets up the mongodb instance
#
class profile::mongodb (

  $mongodb_nodes       = '', # A string f.e. '[ "10.0.2.12", "10.0.2.23" ]'
  $shared_key          = undef,
  $replset_auth_enable = false,
  $service_ensure      = 'running',
  $service_enable      = true,
  $dbpath              = '/var/lib/mongo',
  $storage_device      = undef
) {

  require ::profile::common::packages

  include ::logrotate
  include ::profile::common::concat
  # $dbpath configured in hiera for monitoring
  # FIXME rework cloudwatch to add defines and so manage easily each mount in each profiles
  include ::profile::common::cloudwatch

  profile::register_profile { 'mongodb': }

  # A list of strings, like ['10.0.2.12:27017', '10.0.2.23:27017']
  $_mongo_nodes = suffix(split(regsubst($mongodb_nodes, '[\s\[\]\"]', '', 'G'), ','), ':27017')
  $_mongo_auth_enable = str2bool($replset_auth_enable)

  # explicitly only support replica sets of size 3
  if size($_mongo_nodes) == 3 {
    $replset_name = 'tipaas'

    $replset_config = {
      'tipaas' => {
        ensure  => 'present',
        members => $_mongo_nodes
      }
    }

    if $_mongo_auth_enable == true {
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

  class { '::profile::common::mount_device':
    device  => $storage_device,
    path    => $dbpath,
    options => 'noatime,nodiratime,noexec'
  } ->
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
    keyfile        => $keyfile,
    service_ensure => $service_ensure,
    service_enable => $service_enable,
    dbpath         => $dbpath
  } ->
  class { '::mongodb::client':
  }

  if $service_ensure == 'running' {
    $instanceLogicalId = pick($::cfn_resource_name, $::ec2_userdata, '')
    if $instanceLogicalId =~ /InstanceA/ {
      exec { 'setup MongoDB admin user':
        command => $create_admin_user,
        creates => '/var/lock/mongo_admin_user_lock',
        require => Class['::mongodb::client']
      }
    }
  }

  contain ::mongodb::server
  contain ::mongodb::client

}
