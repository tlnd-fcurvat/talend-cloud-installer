# tomcat syncope  service profile
#
class profile::web::syncope {

  class {'::profile::db::postgresql':
    stage => 'base'
  }
  include ::syncope

}
