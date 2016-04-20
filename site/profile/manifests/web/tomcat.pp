# -*- mode: puppet -*-
# vi: set ft=puppet
#
# === Authors
# Andreas Heumaier <andreas.heumaier@nordcloud.com>
#
class profile::web::tomcat {



  class { '::tomcat': }
  class { '::java': }

  tomcat::instance { 'default':
    catalina_base => '/opt/apache-tomcat/default',
    source_url    => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz',
  } ->
  tomcat::config::server::context { 'default-test':
    catalina_base         => '/opt/apache-tomcat/default',
    context_ensure        => 'present',
    doc_base              => 'test.war',
    parent_service        => 'Catalina',
    parent_engine         => 'Catalina',
    parent_host           => 'localhost',
    additional_attributes => {
      'path' => '/test',
    },
  } ->
  tomcat::config::server{ 'default':
    port    => '8080',
    address => '127.0.0.1'
  }

  profile::register_profile{ 'tomcat': }




  # configuring tomcat server contexts applications from hiera
  #$tomcat_server_contexts = hiera_hash('tomcat_server_contexts', {})
  #create_resources('tomcat::config::server::context', $tomcat_server_contexts)

}