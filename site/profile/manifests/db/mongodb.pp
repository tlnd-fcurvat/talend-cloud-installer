class profile::db::mongodb {

  class {'::mongodb::server':
    port    => 27018,
    verbose => true,
  }
}