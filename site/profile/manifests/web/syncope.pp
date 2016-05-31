# tomcat syncope  service profile
#
class profile::web::syncope {

  include ::syncope
  include ::profile::db::posgresql

  Tomcat::Instance['tomcat'] -> Class['::syncope']

}