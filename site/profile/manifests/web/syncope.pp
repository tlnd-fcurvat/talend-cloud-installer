# tomcat syncope  service profile
#
class profile::web::syncope {

  package {
    'syncope':
      ensure => installed;
    'syncope-console':
      ensure => installed;
    'syncope-sts':
      ensure => installed;
  }


}