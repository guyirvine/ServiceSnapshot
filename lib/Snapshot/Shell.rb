
def shell(params)
  usage = 'shell :cmd=><cmd string>'
  cmd = get_param(params, :cmd, usage)

  content = `#{cmd}`

  title = "shell: #{cmd}"
  format_output(title, content)
end
