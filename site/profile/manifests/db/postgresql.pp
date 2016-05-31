class profile::db::postgresql {

  class { 'postgresql::server': }

  # get some postgresql databases installed
  $pg_databases = hiera_hash('pg_databases', {})
  create_resources('postgresql::server::db', $pg_databases)

}