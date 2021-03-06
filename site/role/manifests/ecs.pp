#
# ECS instance role
#
class role::ecs {
  require ::profile::base
  require ::profile::docker::host
  require ::profile::docker::registry
  require ::profile::docker::ecs_agent
  require ::profile::common::jsons

  role::register_role { 'ecs': }
}
