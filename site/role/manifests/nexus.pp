#
# Nexus Repository role
#
class role::nexus {

  include ::profile::base
  include ::profile::web::nginx
  include ::profile::nexus

}
