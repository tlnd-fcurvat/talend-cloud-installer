#
# Configures Cloudwatch Agent with Hiera-defined log files
#
class profile::common::cloudwatch (

  $include = true,

) {

  if $include {
    require ::pip

    class { '::cloudwatch':
      metrics => hiera_hash('cloudwatch::metrics', {})
    }
  }

}
