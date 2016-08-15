require 'net/ssh/gateway'

class ParameterMissingError < StandardError
end

def get_param(params, name, usage)
  return params[name] unless params[name].nil?
  return ENV[name.to_s] unless ENV[name.to_s].nil?

  msg = "*** Could not find parameter, #{name}, for command, " \
        "#{caller[0][/`.*'/][1..-2]}\n" \
        "*** #{usage}\n" \
        "*** Try :#{name}=>'YourValue'"

  fail ParameterMissingError, msg
end

def env(*args)
  fail 'Must have an even number of argument to env' if args.length.odd?

  (0..args.length - 1).step(2) do |i|
    ENV[args[i]] = args[i + 1]
  end
end

def open_gateway(user, host)
  log "Opening SSH Gateway to, #{host}", true
  gateway = Net::SSH::Gateway.new(host, user)
  local_port = 29_000
  opened = false
  while opened == false
    local_port += 1
    begin
      gateway.open('127.0.0.1', 11_300, local_port)
      opened = true
    rescue Errno::EADDRINUSE
      log "Errno::EADDRINUSE: #{local_port}, Trying next port up.", true
    end
  end
  [local_port, gateway]
end

def log(string, verbose = false)
  return if ENV['TESTING'] == 'true'
  return unless !ENV['VERBOSE'].nil? || verbose == false

  type = verbose ? 'VERB' : 'INFO'
  timestamp = Time.new.strftime('%Y-%m-%d %H:%M:%S')
  puts "[#{type}] #{timestamp} :: #{string}"
end

def format_output(title, content)
  puts "\n===> #{title} <===\n#{content}"
end

def dsl_directory
  "#{ENV['HOME']}/servicesnapshot"
end

def get_file_name(path)
  path = "#{path}.dsl" if File.extname(path) == ''

  p = path
  return p if File.exist?(p)

  p = "#{dsl_directory}/#{path}"
  return p if File.exist?(p)

  abort("Could not find the dsl you passed in, #{path}")
end
