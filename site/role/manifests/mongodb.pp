#
# MongoDB instance role
#
class role::mongodb {

  include ::profile::base
  include ::profile::mongodb

  role::register_role { 'mongodb': }

}
