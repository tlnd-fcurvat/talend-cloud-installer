# Nexus Repository role
#
class role::nexus {

  # This role would be made of all the profiles that need to be included to make a database server work
  # All roles should include the base profile
  include ::profile::base
  include ::profile::web::nginx
  include ::profile::db::nexus

}