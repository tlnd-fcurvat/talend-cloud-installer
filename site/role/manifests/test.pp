#
# Test Instance of the Debug stack
#
class role::test {

  include ::profile::base

  role::register_role { 'test': }

}
