# -*- mode: puppet -*-
# vi: set ft=puppet
#
# === Authors
# Andreas Heumaier <andreas.heumaier@nordcloud.com>
#
class profile::web::tomcat {



  class { '::tomcat': }
  class { '::java': }

  tomcat::instance { 'instance1':
    catalina_base => '/opt/apache-tomcat/instance1',
    source_url    => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz',
  } ->

  tomcat::config::server{ 'instance1':
    catalina_base => '/opt/apache-tomcat/instance1',
    port    => '8080',
  } ->
  tomcat::config::server::context { 'instance1-test':
    catalina_base         => '/opt/apache-tomcat/instance1',
    context_ensure        => 'present',
    doc_base              => 'test.war',
    parent_service        => 'Catalina',
    parent_engine         => 'Catalina',
    parent_host           => 'localhost',
    additional_attributes => {
      'path' => '/test',
    },
  } ->

  tomcat::service { 'instance1':
    catalina_base => '/opt/apache-tomcat/instance1',
  }

  profile::register_profile{ 'tomcat': }




  # configuring tomcat server contexts applications from hiera
  #$tomcat_server_contexts = hiera_hash('tomcat_server_contexts', {})
  #create_resources('tomcat::config::server::context', $tomcat_server_contexts)

}

define configure_hiera_servers {}
define configure_hiera_contexts {}
define configure_hiera_instances {}