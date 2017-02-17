#
#
class role::management_proxy(
  $elasticsearch_host,
  $elasticsearch_url_scheme = 'https',
) {

  include ::profile::base
  include ::profile::web::nginx

  $elasticsearch_url = "${elasticsearch_url_scheme}://${elasticsearch_host}"

  nginx::resource::vhost { 'es-sys':
    server_name  => ['_'],
    listen_port  => '8080',
    proxy        => $elasticsearch_url
  }
}
