require "beanstalk-client"

def beanstalk_queue( params )

    usage = "beanstalk_queue :user=><username>, :host=><hostname>, :queue=><queue|[queue1,queue2,...]>"
    user = get_param( params, :user, usage )
    host = get_param( params, :host, usage )
    queue = get_param( params, :queue, usage )


    localPort, gateway = open_gateway( user, host )

    destinationUrl = "127.0.0.1:#{localPort}"
    log "Opened SSH Gateway to, #{host}, on, #{destinationUrl}", true
    list = Array.new
    log "Connect to remote beanstalk", true
    beanstalk = Beanstalk::Pool.new([destinationUrl])
    beanstalk.watch( queue )
    tubeStats = beanstalk.stats_tube( queue )
    index = tubeStats["current-jobs-ready"].to_i
    log "Current number of msgs in tube, #{index}", true
    jobList = Array.new
    list = Array.new
    1.upto(index) do
        job = beanstalk.reserve 1
        jobList << job
        list << job.body
    end
    
    jobList.each do |job|
        job.release
    end
    
    title = "# beanstalk_queue: #{user}@#{host} #{queue}"
    formatOutput( title, "\n==> MSG <==\n\n" + list.join( "\n==> MSG <==\n\n" ) + "\n\n" )
end


def beanstalk( params )
    usage = "beanstalk :user=><username>, :host=><hostname>, :queues=><queue|[queue1,queue2,...]>"
    user = get_param( params, :user, usage )
    host = get_param( params, :host, usage )

    queues = nil
    begin
        queues = get_param( params, :queues, usage )
        rescue ParameterMissingError=>e
    end
    queues = [queues] if queues.class.name == "String"

    localPort, gateway = open_gateway( user, host )
    
    destinationUrl = "127.0.0.1:#{localPort}"
    log "Opened SSH Gateway to, #{host}, on, #{destinationUrl}", true
    list = Array.new
    log "Connect to remote beanstalk", true
    beanstalk = Beanstalk::Pool.new([destinationUrl])
    
    hash = Hash.new
    beanstalk.list_tubes[destinationUrl].each do |name|
        tubeStats = beanstalk.stats_tube(name)
        hash[name] = tubeStats["current-jobs-ready"].to_s
    end
    
    if queues.nil? then
        hash.each do |k,v|
            list << "#{k}(#{v})"
        end
    else
        queues.each do |k|
            list << "#{k}(#{hash[k]})"
        end
    end
    
    title = "beanstalk: #{user}@#{host} #{queues}"
    formatOutput( title, list.join( "\n" ) )
end

