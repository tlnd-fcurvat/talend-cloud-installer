#
# Sets up the mongodb instance
#
class profile::mongodb {

  require ::profile::common::packages
  require ::mongodb::client

  include ::profile::common::concat

  profile::register_profile { 'mongodb': }

  class { '::mongodb::server':
    verbose => true,
    auth    => true,
  }

  contain ::mongodb::server

  mongodb::db { 'testdb':
    user          => 'user1',
    password_hash => 'a15fbfca5e3a758be80ceaf42458bcd8', # 'password_hash' is hex encoded md5 hash of "user1:mongo:pass1".
  }

}
