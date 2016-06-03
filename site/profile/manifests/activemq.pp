# tomcat activemq  service profile
#
class profile::activemq {

  include ::java
  include ::activemq
  include ::profile::db::postgresql

  profile::register_profile{ 'activemq': }


}