# -*- mode: puppet -*-
# vi: set ft=puppet
#
# === Authors
# Andreas Heumaier <andreas.heumaier@nordcloud.com>
#
class profile::web::tomcat (




){


  class { '::jdk_oracle': } ->

  tomcat::instance { 'instance1':
    install_from_source => true,
    source_url          => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz',
    manage_user         => true,
    manage_group        => true,
    user                => 'tomcat',
    group               => 'tomcat',
    catalina_base       => '/opt/apache-tomcat/instance1',
    catalina_home       => undef,
    java_home           => '/opt/jdk-7',
  } ->

  tomcat::config::server{ 'instance1':
    catalina_base => '/opt/apache-tomcat/instance1',
    port          => '8080',
  } ->
  # tomcat::config::server::context { 'instance1-test':
  #   catalina_base         => '/opt/apache-tomcat/instance1',
  #   context_ensure        => 'present',
  #   doc_base              => 'test.war',
  #   parent_service        => 'Catalina',
  #   parent_engine         => 'Catalina',
  #   parent_host           => 'localhost',
  #   additional_attributes => {
  #     'path' => '/test',
  #   },
  #} ->

  tomcat::service { 'instance1':
    catalina_base => '/opt/apache-tomcat/instance1',
    use_init      => false,
  }

  profile::register_profile{ 'tomcat': }


}
