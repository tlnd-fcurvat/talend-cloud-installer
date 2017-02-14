#
# Kafka instance role
#
class role::kafka {
  include ::profile::base
  include ::profile::kafka

  role::register_role { 'kafka': }
}
