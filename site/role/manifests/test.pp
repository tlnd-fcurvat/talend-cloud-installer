#
# Test Instance of the Debug stack
#
class role::test {

  require ::profile::base
  require ::pip

  role::register_role { 'test': }

  pip::install { 'invoke': }

}
