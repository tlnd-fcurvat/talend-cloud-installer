class profile::full_java_stack {

  include ::profile::web::nginx
  include ::profile::web::tomcat

}