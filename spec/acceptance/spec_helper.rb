require 'serverspec'
Dir[Pathname.new(File.dirname(__FILE__)).join('shared/**/*.rb')].each{ |f| require f }

RSpec.configure do |config|
  set :host, ENV['KITCHEN_HOSTNAME']
  set :ssh_options,
    :user => ENV['KITCHEN_USERNAME'],
    :port => ENV['KITCHEN_PORT'],
    :auth_methods => [ 'publickey' ],
    :keys => ENV['KITCHEN_SSH_KEY']
  set :backend, :ssh
  set :request_pty, true
end
