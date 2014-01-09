Gem::Specification.new do |s|
  s.name        = 'servicesnapshot'
  s.version     = '0.0.5'
  s.date        = '2014-01-09'
  s.summary     = "ServiceSnapshot"
  s.description = "The fastest way to get a snapshot of your system."
  s.authors     = ["Guy Irvine"]
  s.email       = 'guy@guyirvine.com'
  s.files       = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.homepage    = 'http://rubygems.org/gems/servicesnapshot'
#s.add_dependency( "parse-cron" )
#s.add_dependency( "beanstalk-client" )
#s.add_dependency( "fluiddb" )
  s.executables << 'servicesnapshot'
end

