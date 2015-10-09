#!/usr/bin/env rake

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:chefspec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'foodcritic'
FoodCritic::Rake::LintTask.new

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue
  puts '>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end

task :default => %w( rubocop foodcritic chefspec )
task :all => %w( default kitchen:all )
