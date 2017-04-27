#
# Creates a MongoDB user
# @see https://docs.mongodb.com/manual/reference/method/db.createUser
#
define profile::mongodb::user (

  $username   = $name,
  $password   = undef,
  $db_address = $::profile::mongodb::users::db_address,
  $roles      = [], # an array of hashes, like [{'role'=>'userAdminAnyDatabase', 'db'=>'admin'}, {'role'=>'dbOwner', 'db'=>'ipaas'}]

) {

  if $password {
    $lock_name = "/var/lock/mongo_${username}_user_lock"
    $roles_str = regsubst(to_json_ex($roles), '\"', '\\"', 'G')

    if str2bool($profile::mongodb::replset_auth_enable) and $title != 'db_admin_user' {
      $create_user_cmd = "/usr/bin/mongo -u ${profile::mongodb::admin_username} \
        -p ${profile::mongodb::admin_password} \
        --authenticationDatabase admin \
        ${db_address} --eval \"db.createUser({ \
        user: '${username}', \
        pwd: '${password}', \
        roles: ${roles_str} \
      });\" && /bin/touch ${lock_name}"
    } else {
      $create_user_cmd = "/usr/bin/mongo ${db_address} --eval \"db.createUser({ \
        user: '${username}', \
        pwd: '${password}', \
        roles: ${roles_str} \
      });\" && /bin/touch ${lock_name}"
    }

    exec { "Create MongoDB user : ${username}":
      command => $create_user_cmd,
      creates => $lock_name,
    }
  } else {
    notice("Skipping creating MongoDB user ${username} : empty password")
  }

}
