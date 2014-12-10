require './help_finder'
require 'sinatra/activerecord/rake'
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.pattern = "test/*_spec.rb"
end
task(:default) { require_relative 'test' }