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

    $create_role_cmd = "/usr/bin/mongo ${db_address} --eval \"db.createRole({ \
      role: '${rolename}', \
      privileges: ${privileges_str}, \
      roles: ${roles_str} \
    });\" && /bin/touch ${lock_name}"

    exec { "Create MongoDB role : ${rolename}":
      command => $create_role_cmd,
      creates => $lock_name,
      onlyif  => "test \"true\" = \"$(/usr/bin/mongo --quiet ${db_address} --eval 'db.isMaster().ismaster')\"",
    }
  } else {
    notice("Skipping creating MongoDB role : empty rolename")
  }

}
