class profile::common::mount_device::fixup_ownership(
  $path,
  $owner,
  $group,
  $fixup_ownership_require = undef,
) {

  if $fixup_ownership_require {
    $_fixup_ownership_require = [Mount[$path], $fixup_ownership_require]
  } else {
    $_fixup_ownership_require = Mount[$path]
  }

  exec { "chown -R ${owner}:${group} ${path} && touch /var/tmp/mongo_db_path_ownership_fixup.done":
    path    => '/bin:/usr/bin',
    creates => '/var/tmp/mongo_db_path_ownership_fixup.done',
    require => $_fixup_ownership_require
  }

}
