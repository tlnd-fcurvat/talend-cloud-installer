# Setting up the single nexus instance
#
class profile::db::nexus (

  $nexus_root = '/srv',

) {

  include java

  ensure_packages(['wget'])

  class{ '::nexus':
    version    => '2.8.0',
    revision   => '05',
    nexus_root => $nexus_root, # All directories and files will be relative to this
  }  ->

  exec {
    'disable_anonymous':
      command => "/usr/bin/curl -X PUT -u admin:admin123 http://localhost:8081/nexus/service/local/users/anonymous -H 'Content-type: application/json' -d '{\"data\":{\"userId\":\"anonymous\",\"firstName\":\"Nexus\",\"lastName\":\"Anonymous User\",\"email\":\"changeme2@yourcompany.com\",\"status\":\"disabled\",\"roles\":[\"anonymous\",\"repository-any-read\"]}}'",
      onlyif => '/usr/bin/curl -f http://localhost:8081/nexus/service/local/all_repositories';
    'delete_user_deployment':
      command => '/usr/bin/curl -s -f -X DELETE -u admin:admin123 http://localhost:8081/nexus/service/local/users/deployment',
      onlyif => '/usr/bin/curl -s -f -X GET -u admin:admin123 http://localhost:8081/nexus/service/local/users/deployment';
  }

  Class['::java'] ->
  Class['::nexus']

}
