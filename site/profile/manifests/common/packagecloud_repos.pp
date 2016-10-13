#
# Defines hiera-defined packagecloud repositories
#
class profile::common::packagecloud_repos {

  if size($::packagecloud_master_token) > 0 {
    create_resources(
      'packagecloud::repo',
      hiera_hash('packagecloud_repos', {})
    )
  }

}
