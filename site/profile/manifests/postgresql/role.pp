#
# Creates a database, role and grants access
#
define profile::postgresql::role {

  $role = $profile::postgresql::roles[$name]

  postgresql::server::database { $name:
    owner  => 'tadmin',
    dbname => $name,
  }

  postgresql::server::role { $name:
    password_hash => pick($role['password'], $profile::postgresql::password),
    db            => 'tadmin',
  }

  postgresql::server::database_grant { $name:
    privilege => 'ALL',
    db        => $name,
    role      => $name,
  }

}
