# activemq  service role
#
class role::activemq {


  # This role would be made of all the profiles that need to be included to make a activemq server work
  # All roles should include the base profile
  include ::profile::base
  include ::profile::activemq

}