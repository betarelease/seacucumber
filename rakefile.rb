require 'rubygems'
require 'rake'
require 'spec/rake/spectask'

require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/contrib/sshpublisher'
require 'lib/seacucumber'


task :build => [:rspec, :publish_rdoc]

desc "Run all RSpec "
Spec::Rake::SpecTask.new('rspec') do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Generate RDoc'
Rake::RDocTask.new do |task|
  task.main = 'README'
  task.title = 'Sea Cucumber: In Browser JavaScript Unit Testing'
  task.rdoc_dir = 'doc'
  task.options << "--line-numbers" << "--inline-source"
  task.rdoc_files.include('README', 'lib/**/*.rb')
end

desc "Upload RDoc to RubyForge"
task :publish_rdoc => [:rdoc] do
  Rake::SshDirPublisher.new("mward@rubyforge.org", "/var/www/gforge-projects/seacucumber", "doc").upload
end

Gem::manage_gems

specification = Gem::Specification.new do |s|
  s.name = "seacucumber"
  s.version = SeaCucumber::Version.new.to_s
  s.author = 'Michael Ward, Peter Ryan, Sudhindra Rao'
  s.email = 'seacucumber-developer@rubyforge.org'
  s.homepage = 'http://seacucumber.rubyforge.org'
  s.platform = Gem::Platform::RUBY 
  s.summary = "allows for in browser JavaScript Unit testing directly from your Rake script"
  s.rubyforge_project = 'seacucumber'

  s.files = FileList['lib/**/*.rb', 'spec/**/*.rb', 'tasks/**/*', 'generators/**/*', 'init.rb', 'README'].to_a

  s.require_path = "lib"
  s.autorequire = "seacucumber"
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
  s.add_dependency("rake", ">= 0.7.0") 
end

Rake::GemPackageTask.new(specification) do |package|
  package.need_zip = false
  package.need_tar = true
end

task :default => "pkg/#{specification.name}-#{specification.version}.gem" do
    puts "generated latest version"
end

load File.expand_path(File.dirname(__FILE__) + '/./tasks/seacucumber.rake')
