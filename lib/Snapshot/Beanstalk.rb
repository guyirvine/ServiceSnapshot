require "beanstalk-client"

def beanstalk_queue( params )
    
    abort( "*** Incorrect parameters passed for, beanstalk\n*** Usage, ssh :user=><username>, :host=><hostname>, :queue=><queue|[queue1,queue2,...]>" ) if params.class.name != "Hash" || params.keys.length != 3
    abort( "*** User parameter missing for, beanstalk, command\n*** Add, :user=><username>" ) if params[:user].nil?
    abort( "*** Host parameter missing for, beanstalk, command\n*** Add, :host=><host>" ) if params[:host].nil?
    abort( "*** Queue parameter missing for, beanstalk, command\n*** Add, :queue=><queue>" ) if params[:queue].nil?

    localPort, gateway = open_gateway( params[:user], params[:host] )
    
    destinationUrl = "127.0.0.1:#{localPort}"
    log "Opened SSH Gateway to, #{params[:host]}, on, #{destinationUrl}", true
    list = Array.new
    log "Connect to remote beanstalk", true
    beanstalk = Beanstalk::Pool.new([destinationUrl])
    beanstalk.watch( params[:queue] )
    tubeStats = beanstalk.stats_tube( params[:queue] )
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
    
    title = "# beanstalk_queue: #{params[:user]}@#{params[:host]} #{params[:queue]}"
    formatOutput( title, "\n==> MSG <==\n\n" + list.join( "\n==> MSG <==\n\n" ) + "\n\n" )
end


def beanstalk( params )

    abort( "*** Incorrect parameters passed for, beanstalk\n*** Usage, ssh :user=><username>, :host=><hostname>, :queue=><queue|[queue1,queue2,...]>" ) if params.class.name != "Hash" || params.keys.length < 2 || params.keys.length > 3
    abort( "*** User parameter missing for, beanstalk, command\n*** Add, :user=><username>" ) if params[:user].nil?
    abort( "*** Host parameter missing for, beanstalk, command\n*** Add, :host=><host>" ) if params[:host].nil?
    
    localPort, gateway = open_gateway( params[:user], params[:host] )
    
    destinationUrl = "127.0.0.1:#{localPort}"
    log "Opened SSH Gateway to, #{params[:host]}, on, #{destinationUrl}", true
    list = Array.new
    log "Connect to remote beanstalk", true
    beanstalk = Beanstalk::Pool.new([destinationUrl])
    
    beanstalk.list_tubes[destinationUrl].each do |name|
        tubeStats = beanstalk.stats_tube(name)
        list << name + "(" + tubeStats["current-jobs-ready"].to_s + ")" if params[:queues].nil? or !params[:queues].index( name ).nil?
    end
    
    title = "beanstalk: #{params[:user]}@#{params[:host]} #{params[:queues]}"
    formatOutput( title, list.join( "\n" ) )
end

