class profile::full_java_stack {

  include ::java
  include ::nginx
  include ::tomcat



  #class { 'tomcat': }
  #class { 'java': }


  tomcat::instance { 'default':
    catalina_home => '/opt/tomcat',
  }

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