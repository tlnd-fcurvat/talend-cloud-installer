# tomcat syncope  service role
#
class role::syncope {

  class {
    '::profile::base':
      stage => 'base';
    '::profile::java':
      stage => 'base';
    '::profile::web::syncope':;
  }

}
