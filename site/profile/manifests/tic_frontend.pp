#
# TIC Frontend profile
#
class profile::tic_frontend (

  $version = undef,

) {

  include ::profile::common::concat

  profile::register_profile { 'tic_frontend': }

  if size($version) > 0 {
    $_version = $version
  } else {
    $_version = 'latest'
  }

  class { '::tic::frontend':
    version => $_version,
  }

  contain ::tic::frontend

}
