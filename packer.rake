require 'tilt'

namespace :packer do

  desc 'Build packer template'
  task :template do
    template = "#{File.dirname(__FILE__)}/packer/template.json.erb"
    puts Tilt::ERBTemplate.new(template).render(Object.new, {})
  end

end
