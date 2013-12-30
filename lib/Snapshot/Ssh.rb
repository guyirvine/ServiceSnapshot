require "net/ssh"

def ssh( params )
    
    abort( "*** Incorrect parameters passed for, ssh\n*** Usage, ssh :user=><username>, :host=><hostname>, :cmd=><cmd>" ) if params.class.name != "Hash" || params.keys.length != 3
    abort( "*** User parameter missing for, ssh, command\n*** Add, :user=><username>" ) if params[:user].nil?
    abort( "*** Host parameter missing for, ssh, command\n*** Add, :host=><host>" ) if params[:host].nil?
    abort( "*** Cmd parameter missing for, ssh, command\n*** Add, :cmd=><cmd>" ) if params[:cmd].nil?

    content = ""
    Net::SSH.start(params[:host], params[:user]) do |ssh|
        content = ssh.exec!(params[:cmd])
    end

    title = "ssh: #{params[:user]}@#{params[:host]} #{params[:cmd]}"
    formatOutput( title, content )
end
