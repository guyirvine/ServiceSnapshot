require 'beanstalk-client'

def beanstalk_queue(params)
  usage = "beanstalk_queue :user=><username>, :host=><hostname>, :queue=><queue|[queue1,queue2,...]>"
  user = get_param(params, :user, usage)
  host = get_param(params, :host, usage)
  queue = get_param(params, :queue, usage)

  local_port, gateway = open_gateway( user, host )

  destination_url = "127.0.0.1:#{local_port}"
  log "Opened SSH Gateway to, #{host}, on, #{destination_url}", true
  list = []
  log 'Connect to remote beanstalk', true
  beanstalk = Beanstalk::Pool.new([destination_url])
  beanstalk.watch(queue)
  tube_stats = beanstalk.stats_tube(queue)
  index = tube_stats['current-jobs-ready'].to_i
  log "Current number of msgs in tube, #{index}", true
  job_list = []
  list = []
  1.upto(index) do
    job = beanstalk.reserve 1
    job_list << job
    list << job.body
  end

  job_list.each do |job|
    job.release
  end

  title = "# beanstalk_queue: #{user}@#{host} #{queue}"
  format_output(title, "\n==> MSG <==\n" + list.join("\n==> MSG <==\n") +
                "\n\n")
end

def beanstalk(params)
  usage = 'beanstalk :user=><username>, :host=><hostname>, ' \
          ':queues=><queue|[queue1,queue2,...]>'
  user = get_param(params, :user, usage)
  host = get_param(params, :host, usage)

  queues = nil
  begin
    queues = get_param(params, :queues, usage)
  rescue ParameterMissingError => e
#    log "beanstalk.ParameterMissingError. #{e.message}"
  end
  queues = [queues] if queues.class.name == 'String'

  local_port, _gateway = open_gateway(user, host)

  destination_url = "127.0.0.1:#{local_port}"
  log "Opened SSH Gateway to, #{host}, on, #{destination_url}", true
  list = []
  log 'Connect to remote beanstalk', true
  beanstalk = Beanstalk::Pool.new([destination_url])

  hash = {}
  beanstalk.list_tubes[destination_url].each do |name|
    tube_stats = beanstalk.stats_tube(name)
    hash[name] = tube_stats['current-jobs-ready'].to_s
  end

  if queues.nil?
    hash.each do |k, v|
      list << "#{k}(#{v})"
    end
  else
    queues.each do |k|
      list << "#{k}(#{hash[k]})"
    end
  end

  title = "beanstalk: #{user}@#{host} #{queues}"
  format_output(title, list.join("\n"))
end
