# -*- mode: puppet -*-
# vi: set ft=puppet
#
# === Authors
# Andreas Heumaier <andreas.heumaier@nordcloud.com>
#
class profile::web::tomcat (){

  package{  'ruby-augeas':
    ensure  => 'installed',
    require => Package["epel-release"]
  }


  $dummy = inline_template("<% ENV['JAVA_HOME'] = '/opt/java_home' %>")

  class { '::jdk_oracle': } ->

  tomcat::instance { 'tomcat7':
    install_from_source => true,
    source_url          => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz',
    manage_user         => true,
    manage_group        => true,
    user                => 'tomcat',
    group               => 'tomcat',
    catalina_base       => '/opt/apache-tomcat/tomcat7',
    catalina_home       => undef,
    java_home           => '/opt/jdk-7',
  } ->
  tomcat::service { 'tomcat7':
    catalina_base => '/opt/apache-tomcat/tomcat7',
    use_init      => false,
  }

  profile::register_profile{ 'tomcat': }


}
