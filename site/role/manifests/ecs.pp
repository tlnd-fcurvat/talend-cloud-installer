#
# ECS instance role
#
class role::ecs {
  include ::profile::base
  require ::profile::docker::host
  require ::profile::docker::ecs_agent

  role::register_role { 'ecs': }
}
