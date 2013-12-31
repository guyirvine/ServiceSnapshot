require 'rake/testtask'
ENV["TESTING"]="true"

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test
