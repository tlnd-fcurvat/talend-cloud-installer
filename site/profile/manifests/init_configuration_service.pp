class profile::init_configuration_service (

  $ami_id           = 'missing',
  $security_groups  = 'missing',
  $instance_type    = 'missing',
  $subnet_id        = 'missing',
  $instance_profile = 'missing',

) {

  include ::profile::common::concat

  profile::register_profile { 'init_configuration_service': }

  $service_auth = "-u ${::services_username}:${::services_password}"

  $init_configuration_service_cmd = "/usr/bin/curl --fail \
  -X PUT \
  -d @/var/tmp/init_configuration_service.json \
  -H 'Content-Type: application/json' \
  ${service_auth} \
  http://localhost:8181/services/configuration-service/default"

  file { '/var/tmp/init_configuration_service.json':
    content => template('installer/var/tmp/init_configuration_service.json.erb'),
  } ->
  exec { 'init configuration-service':
    command   => $init_configuration_service_cmd,
    tries     => 30,
    try_sleep => 10,
    unless    => "/usr/bin/curl http://localhost:8181/services/configuration-service/default?p=nodeman.ami.version_1_3 ${service_auth} | grep ${ami_id}"
  }

}
