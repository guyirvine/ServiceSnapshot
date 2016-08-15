require 'net/ssh'

def ssh(params)
  usage = 'ssh :user=><username>, :host=><hostname>, :queues=><queue|[queue1,queue2,...]>'
  user = get_param(params, :user, usage)
  host = get_param(params, :host, usage)
  cmd = get_param(params, :cmd, usage)

  content = ''
  Net::SSH.start(host, user) do |ssh|
    content = ssh.exec!(cmd)
  end

  title = "ssh: #{user}@#{host} #{cmd}"
  format_output(title, content)
end
