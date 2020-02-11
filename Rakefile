require_relative 'config/environment'
require 'sinatra/activerecord/rake'



desc 'starts a console'
task :console do
  sh 'rake db:rollback STEP=3'
  sh 'rake db:migrate'
  sh 'rake db:seed'
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end