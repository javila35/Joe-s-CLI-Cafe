require_relative 'config/environment'
require 'sinatra/activerecord/rake'


desc 'resets database'
task :reset do
  sh 'rake db:rollback STEP=3'
  sh 'rake db:migrate'
  sh 'rake db:seed'
end

desc 'starts a console'
task :console do
  # ActiveRecord::Base.logger = Logger.new(STDOUT)
  # Pry.start
  sh 'ruby bin/run.rb'
end