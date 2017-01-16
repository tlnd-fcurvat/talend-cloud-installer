class profile::mongodb::replset_reconfigure (

  $replset_size = undef,
  $address      = 'admin',
  $instructions = [], # array of strings

) {

  $instructions_size = size($instructions)
  if $replset_size >= 3 and $instructions_size > 0 {
    if $profile::mongodb::service_ensure == 'running' {
      $lock_name = "/var/lock/mongo_replset_reconfigure_lock"
      $instructions_str = join($instructions, ' ')

      $cmd = "/usr/bin/mongo ${address} --eval \"cfg = rs.conf(); ${instructions_str} rs.reconfig(cfg);\" && /bin/touch ${lock_name}"

      exec { "Reconfigure replset":
        command => $cmd,
        creates => $lock_name,
        onlyif  => "test \"true\" = \"$(/usr/bin/mongo --quiet ${address} --eval 'db.isMaster().ismaster')\"",
      }
    }
  } else {
    notice("Skipping replset reconfigure : replset_size = ${replset_size} and instructions_size = ${instructions_size}")
  }

}
