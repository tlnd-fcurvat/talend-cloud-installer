#
# Creates a MongoDB role
# @see https://docs.mongodb.com/manual/reference/method/db.createRole
#
define profile::mongodb::role (

  $rolename   = $name,
  $db_address = $::profile::mongodb::roles::db_address,
  $privileges = [],
  $roles      = [],

) {

  if $rolename {
    $lock_name      = "/var/lock/mongo_${rolename}_role_lock"
    $privileges_str = regsubst(to_json_ex($privileges), '\"', '\\"', 'G')
    $roles_str      = regsubst(to_json_ex($roles), '\"', '\\"', 'G')

    if str2bool($profile::mongodb::replset_auth_enable) {
      $create_role_cmd = "/usr/bin/mongo ${db_address} \
        -u ${profile::mongodb::admin_username} \
        -p ${profile::mongodb::admin_password} \
        --authenticationDatabase admin \
        --eval \"db.createRole({ \
        role: '${rolename}', \
        privileges: ${privileges_str}, \
        roles: ${roles_str} \
      });\" && /bin/touch ${lock_name}"
    } else {
      $create_role_cmd = "/usr/bin/mongo ${db_address} --eval \"db.createRole({ \
        role: '${rolename}', \
        privileges: ${privileges_str}, \
        roles: ${roles_str} \
      });\" && /bin/touch ${lock_name}"
    }

    exec { "Create MongoDB role : ${rolename}":
      command => $create_role_cmd,
      creates => $lock_name,
    }
  } else {
    notice('Skipping creating MongoDB role : empty rolename')
  }

}
