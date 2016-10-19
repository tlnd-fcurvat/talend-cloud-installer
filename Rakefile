(require 'puppetlabs_spec_helper/rake_tasks', true) rescue true
(require 'puppet-lint/tasks/puppet-lint', true) rescue true
require 'tilt'

begin
  PuppetLint.configuration.send('disable_80chars')
  PuppetLint.configuration.send('disable_puppet_url_without_modules')
  PuppetLint.configuration.send('disable_quoted_booleans')
  PuppetLint.configuration.ignore_paths = %w(
    spec/**/*.pp
    pkg/**/*.pp
    vendor/**/*.pp
    test/**/*.pp
    modules/**/*.pp
  )
rescue
end

desc 'Validate manifests, templates, and ruby files'
task :validate do
  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['site/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['spec/**/*.rb','lib/**/*.rb'].each do |ruby_file|
    sh "ruby -c #{ruby_file}" unless ruby_file =~ /spec\/fixtures/
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
end

namespace :packer do

  desc 'Build packer template'
  task :template do
    template = "#{File.dirname(__FILE__)}/packer/template.json.erb"
    puts Tilt::ERBTemplate.new(template).render(Object.new, {})
  end

end
