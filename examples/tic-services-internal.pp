class { '::profile::base':
} ->
package { 'ptic-postgresql-schemes':
} ->
class { '::profile::postgresql':
  roles => {
    'config' => {
      'files' => ['/var/tmp/sql/config.sql']
    }
  },
} ->
class { '::profile::postgresql::provision':
} ->
class { '::role::tic_services_internal':
}
