require 'rake/testtask'
ENV["TESTING"]="true"

Rake::TestTask.new do |t|
  t.libs << 'test'
end

task :build do
  `gem build servicesnapshot.gemspec`
end

task :install do
  Rake::Task['build'].invoke
  cmd = "sudo gem install ./#{Dir.glob('servicesnapshot*.gem').sort.pop}"
  p "cmd: #{cmd}"
  `#{cmd}`
  p "gem push ./#{Dir.glob('servicesnapshot*.gem').sort.pop}"
end

desc "Run tests"
task :default => :test
