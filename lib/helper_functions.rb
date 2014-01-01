require "net/ssh/gateway"

class ParameterMissingError<StandardError
end

def get_param( params, name, usage )
    return params[name] unless params[name].nil?
    return ENV[name.to_s] unless ENV[name.to_s].nil?


msg = %{*** Could not find parameter, #{name.to_s}, for command, #{caller[0][/`.*'/][1..-2]}
*** #{usage}
*** Try :#{name.to_s}=>'YourValue'
}

    raise ParameterMissingError.new( msg )
end

def env( *args )
    raise "Must have an even number of argument to env" if args.length % 2 != 0
    
    (0..args.length-1).step(2) do |i|
        ENV[args[i]] = args[i+1]
    end
end

def open_gateway( user, host )
    log "Opening SSH Gateway to, #{host}", true
    gateway = Net::SSH::Gateway.new(host, user)
    localPort = 29000
    opened = false
    while opened==false
        localPort = localPort + 1
        begin
            gateway.open('127.0.0.1', 11300, localPort)
            opened=true
            rescue Errno::EADDRINUSE
        end
    end
    return [localPort,gateway]
end


def log( string, verbose=false )
    return if ENV["TESTING"]=="true"
    
    type = verbose ? "VERB" : "INFO"
	if !ENV["VERBOSE"].nil? || verbose==false then
        timestamp = Time.new.strftime( "%Y-%m-%d %H:%M:%S" )
        puts "[#{type}] #{timestamp} :: #{string}"
    end
end

def formatOutput( title, content )
    puts "\n===> #{title} <===\n#{content}"
end

def getDslDirectory
    return "#{ENV['HOME']}/servicesnapshot"
end


def getFileName( path )
    path = "#{path}.dsl" if File.extname(path) == ""
    
    p = path
    return p if File.exists?( p )

    p = "#{getDslDirectory}/#{path}"
    return p if File.exists?( p )

    abort( "Could not find the dsl you passed in, #{path}" )
end

