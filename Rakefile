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
  sh 'ruby bin/run.rb'
end

# desc 'Runs an interactive tutorial.'
# task :test do
#   [:console]
#   sh 'Customer.visit'
# end