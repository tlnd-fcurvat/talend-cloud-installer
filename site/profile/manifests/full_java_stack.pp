class profile::full_java_stack {

  #include ::java
  include ::nginx
  #include ::tomcat

  #tomcat::install { '/opt/tomcat/':
  #  source_url => 'https://www-us.apache.org/dist/tomcat/tomcat-7/v7.0.69/bin/apache-tomcat-7.0.69.tar.gz',
  #}
  #tomcat::instance { 'default':
  #  catalina_home => '/opt/tomcat/',
  #}


  class { 'tomcat': }
  class { 'java': }


  tomcat::instance { 'default':
    catalina_home => '/opt/tomcat',
  }


 # tomcat::instance { 'mycat':
 #   catalina_base => '/opt/apache-tomcat/',
 #   source_url    => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz',
 #}

  #->
  # tomcat::config::server::context { 'mycat-test':
  #   catalina_base         => '/opt/apache-tomcat/mycat',
  #   context_ensure        => present,
  #   doc_base              => 'test.war',
  #   parent_service        => 'Catalina',
  #   parent_engine         => 'Catalina',
  #   parent_host           => 'localhost',
  #   additional_attributes => {
  #     'path' => '/test',
  #   },
  # }


}