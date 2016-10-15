#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
# require 'Word_Train/word_train'

spec = Gem::Specification.find_by_name 'word_train'
load "#{spec.gem_dir}/lib/tasks/word_train.rake"
# load "#{spec.gem_dir}/lib/Word_Train/word_train.rb"

Bundler::GemHelper.install_tasks
# APP_RAKEFILE = File.expand_path('../test/dummy/Rakefile', __FILE__)
RSpec::Core::RakeTask.new(:spec)

task :default => :spec



# https://github.com/rharriso/bower-rails/issues/42

