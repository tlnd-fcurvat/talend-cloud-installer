class profile::tic_services_external::nginx {

  include ::nginx

  nginx::resource::vhost {
    'webhooks':
      listen_port => 8182,
      proxy       => 'http://localhost:8181/services/webhooks-service/';

    'dts':
      listen_port => 8183,
      proxy       => 'http://localhost:8181/services/data-transfer-service/';

    'lts':
      listen_port => 8184,
      proxy       => 'http://localhost:8181/services/logs-transfer-service-runtime/';

    'pairing':
      listen_port => 8185,
      proxy       => 'http://localhost:8181/services/pairing-service/';
  }

  nginx::resource::location {
    'webhooks_status':
      location => '/status',
      vhost    => 'webhooks',
      proxy    => 'http://localhost:8181/services/healthcheck/is-ok';

    'dts_status':
      location => '/status',
      vhost    => 'dts',
      proxy    => 'http://localhost:8181/services/healthcheck/is-ok';

    'lts_status':
      location => '/status',
      vhost    => 'lts',
      proxy    => 'http://localhost:8181/services/healthcheck/is-ok';

    'pairing_status':
      location => '/status',
      vhost    => 'pairing',
      proxy    => 'http://localhost:8181/services/healthcheck/is-ok';
  }

}
