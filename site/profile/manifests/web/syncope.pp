# tomcat syncope  service profile
#
class profile::web::syncope {

  class{ '::syncope':
    java_home         => $::java_default_home,
    postgres_username => 'postgres',
    postgres_password => $::master_password,
    postgres_node     => 'localhost',
    application_path  => '/opt/tomcat/webapps',
    admin_password    => $::master_password,
  }

  class { 'postgresql::server': }

  postgresql::server::db { 'syncope':
    user     => 'syncope',
    password => postgresql_password('syncope', $::master_passwords),
  }

  Tomcat::Instance['tomcat'] -> Class['::syncope']

}