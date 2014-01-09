require "FluidDb"

def padStringWithWhiteSpace( string, length )
    while string.length <= length+1
        string = string + " "
    end
    return string
end

def fluiddb( params )
    usage = "fluiddb :uri=><uri>, :sql=><sql>"
    uri_string = get_param( params, :uri, usage )
    sql_string = get_param( params, :sql, usage )
    
    db = FluidDb::Db( URI.parse( uri_string ) )
    list = db.queryForResultset( sql_string, [] )
    content = ""
    if list.count == 0 then
        content = "No rows returned"
        else
        
        max_width = Array.new( list[0].keys.length, 0 )
        list[0].keys.each_with_index do |k,idx|
            max_width[idx] = k.length if max_width[idx] < k.length
            list.each do |row|
                max_width[idx] = row[k].to_s.length if max_width[idx] < row[k].to_s.length
            end
        end

        fieldNames = ""
        underLines = ""
        list[0].keys.each_with_index do |fieldName, idx|
            fieldNames = fieldNames + padStringWithWhiteSpace( fieldName, max_width[idx])
            underLines = underLines + padStringWithWhiteSpace( "=" * max_width[idx], max_width[idx])
        end

        content = "#{fieldNames}\n#{underLines}\n"
        
        list.each do |row|
            row.values.each_with_index do |v,idx|
                content = content + padStringWithWhiteSpace( v.to_s, max_width[idx])
            end
            content = content + "\n"
        end
    end

    title = "fluiddb: #{uri_string} = #{sql_string}"
    formatOutput( title, content )
end
