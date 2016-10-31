#
# Installs Amazon SSM agent
#
class profile::common::ssm (

  $include        = true,
  $region         = undef,
  $service_enable = true,
  $service_ensure = running,

) {

  if $include {
    $url  = "amazon-ssm-${region}.s3.amazonaws.com/latest/linux_amd64/amazon-ssm-agent.rpm"
    $path = '/opt/amazon-ssm-agent.rpm'

    exec { 'download-ssm-agent':
      command => "/usr/bin/wget -T60 -N https://${url} -O ${path}",
      path    => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      creates => $path,
    } ->
    package { 'amazon-ssm-agent':
      source => $path,
    } ->
    service { 'amazon-ssm-agent':
      ensure => $service_ensure,
      enable => $service_enable,
    }
  }

}
