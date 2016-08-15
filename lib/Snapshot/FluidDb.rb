require 'FluidDb'

def pad_string_with_white_space(string, length)
  while string.length <= length + 1
    string += ' '
  end
  string
end

def fluiddb(params)
  usage = 'fluiddb :uri=><uri>, :sql=><sql>'
  uri_string = get_param(params, :uri, usage)
  sql_string = get_param(params, :sql, usage)

  db = FluidDb::Db(URI.parse(uri_string))
  list = db.queryForResultset(sql_string, [])
  content = ''
  if list.count == 0
    content = 'No rows returned'
  else

    max_width = Array.new(list[0].keys.length, 0)
    list[0].keys.each_with_index do |k, idx|
      max_width[idx] = k.length if max_width[idx] < k.length
      list.each do |row|
        max_width[idx] = row[k].to_s.length if max_width[idx] < row[k].to_s.length
      end
    end

    field_names = ''
    under_lines = ''
    list[0].keys.each_with_index do |field_name, idx|
      field_names += pad_string_with_white_space(field_name, max_width[idx])
      under_lines += pad_string_with_white_space('=' * max_width[idx], max_width[idx])
    end

    content = "#{field_names}\n#{under_lines}\n"

    list.each do |row|
      row.values.each_with_index do |v, idx|
        content += pad_string_with_white_space(v.to_s, max_width[idx])
      end
      content += "\n"
    end
  end

  title = "fluiddb: #{uri_string} = #{sql_string}"
  format_output(title, content)
end
