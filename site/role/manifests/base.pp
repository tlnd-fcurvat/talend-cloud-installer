# Example role for testing purposes
#
class role::base {

  # This role would be made of all the profiles that need to be included to make a base server work
  # All roles should include the base profile
  include ::profile::base

  $cloudwatch_logfiles = hiera_hash('cloudwatchlog_files', {})
  create_resources('::cloudwatchlogs::log', $cloudwatch_logfiles)


}
