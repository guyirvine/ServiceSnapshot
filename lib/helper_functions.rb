require "net/ssh/gateway"

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
