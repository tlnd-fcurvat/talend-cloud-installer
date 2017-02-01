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

  if $::environment == 'ami' {

    class {
      'profile::build_time_facts':
        facts_hash => {'ipaas_frontend_build_version' => $_version}
    }
  }

  if versioncmp($::ipaas_frontend_build_version, '2.0') > 0 {
      include 'tic::frontend20'
  }


}
