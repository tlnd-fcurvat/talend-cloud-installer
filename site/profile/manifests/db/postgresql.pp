# setting up server instance of databases for application roles
#

class profile::db::postgresql(
  $pg_role_user=undef,
  $pg_role_user_password=undef,
  $pg_role_db_name=undef) {

  include ::postgresql::server

  # get some postgresql databases installed
  $pg_databases = hiera_hash('pg_databases', {})

  create_resources('postgresql::server::database', $pg_databases)

  Postgresql::Server::Database <| |> -> Postgresql::Server::Database_grant <| |>

  if $pg_role_user {

    postgresql_psql { "CREATE ROLE ${pg_role_user}":
      command          => "CREATE ROLE \"${pg_role_user}\" WITH LOGIN PASSWORD '\$NEWPGPASSWD'",
      unless           => "SELECT rolname FROM pg_roles WHERE rolname='${pg_role_user}'",
      environment      => "NEWPGPASSWD=${pg_role_user_password}",
      require          => Class['Postgresql::Server'],
      connect_settings => $postgresql::server::default_connect_settings
    } ->

    postgresql::server::database_grant { 'database_grant':
      privilege => 'ALL',
      db        => $pg_role_db_name,
      role      => $pg_role_user,
    }
  }
}

