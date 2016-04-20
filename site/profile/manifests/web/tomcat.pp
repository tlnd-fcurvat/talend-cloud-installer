# -*- mode: puppet -*-
# vi: set ft=puppet
#
# === Authors
# Andreas Heumaier <andreas.heumaier@nordcloud.com>
#
class profile::web::tomcat {

  include ::java
  include ::tomcat

  profile::register_profile{ 'tomcat': }

  tomcat::instance { 'default':
    catalina_home => '/opt/tomcat',
  }
  #
  # configuring tomcat server contexts applications from hiera
  $tomcat_server_contexts = hiera_hash('tomcat_server_contexts', {})

}