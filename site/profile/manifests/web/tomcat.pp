# -*- mode: puppet -*-
# vi: set ft=puppet
#
# === Authors
# Andreas Heumaier <andreas.heumaier@nordcloud.com>
#
class profile::web::tomcat {



  class { '::tomcat': }
  class { '::java': }

  tomcat::instance { 'mycat':
    catalina_base => '/opt/apache-tomcat/mycat',
    source_url    => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz',
  }->
  tomcat::config::server::context { 'mycat-test':
    catalina_base         => '/opt/apache-tomcat/mycat',
    context_ensure        => present,
    doc_base              => 'test.war',
    parent_service        => 'Catalina',
    parent_engine         => 'Catalina',
    parent_host           => 'localhost',
    additional_attributes => {
      'path' => '/test',
    },
  }




  #
  # include ::java
  # include ::tomcat
  #
  # profile::register_profile{ 'tomcat': }
  #
  # tomcat::instance { 'default':
  #   source_url    => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz',
  #   catalina_home => '/opt/tomcat',
  # }
  #
 # tomcat::config::server{'default':
 #   port    => '8080',
 #   address => '127.0.0.1'
 # }

  # configuring tomcat server contexts applications from hiera
  #$tomcat_server_contexts = hiera_hash('tomcat_server_contexts', {})
  #create_resources('tomcat::config::server::context', $tomcat_server_contexts)

}