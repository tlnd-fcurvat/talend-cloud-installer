#
# Installs Amazon SSM agent
#
class profile::common::ssm (

  $region         = undef,
  $manage_service = true,

) {

  class { 'ssm':
    region         => $region,
    manage_service => $manage_service,
  }

}
