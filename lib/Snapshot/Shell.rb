require "net/ssh"

def shell( params )
    usage = "shell :cmd=><cmd string>"
    cmd = get_param( params, :cmd, usage )
    
    #    content = system cmd
    content = `#{cmd}`
    
    title = "shell: #{cmd}"
    formatOutput( title, content )
end
