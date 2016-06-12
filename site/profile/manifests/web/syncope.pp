# tomcat syncope  service profile
#
class profile::web::syncope {

  include ::syncope
  include ::profile::db::postgresql

}
