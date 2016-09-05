#
# Creates a database, role and grants access
#
define profile::postgresql::role {

  $role = $profile::postgresql::roles[$name]

  postgresql::server::database { $name:
    dbname => $name,
    owner  => $profile::postgresql::username,
  }

  postgresql::server::role { $name:
    password_hash => pick($role['password'], $profile::postgresql::password),
    db            => $profile::postgresql::database,
  }

  postgresql::server::database_grant { $name:
    privilege => 'ALL',
    db        => $name,
    role      => $name,
  }

}
