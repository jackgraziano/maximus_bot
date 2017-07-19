def run_ipdo
  today = Date.today
  weekday = ["segunda", "terça", "quarta", "quinta", "sexta", "sábado", "domingo"][today.wday-1]
  threads = []

  if ["sábado", "domingo"].include? weekday
    send_slack('#ipdo', "Hoje é #{weekday} Bom fim de semana.")
  elsif weekday == "segunda"
    send_slack('#ipdo', "Hoje é #{weekday}. Vou monitorar os IPDOS de sexta, sábado e domingo.")
    threads << Thread.new { wait_for_ipdo(today - 1) }
    threads << Thread.new { wait_for_ipdo(today - 2) }
    threads << Thread.new { wait_for_ipdo(today - 3) }
  else
    send_slack('#ipdo', "Hoje é #{weekday}. Vou monitorar o IPDO de ontem.")
    threads << Thread.new { wait_for_ipdo(today - 1) }
  end

  threads.each do |thread|
    thread.join
  end
end

def ipdo_file_name(date)
  day = date.day.to_s.rjust(2, '0')
  month = date.month.to_s.rjust(2, '0')
  year = date.year.to_s.rjust(4, '0')
  filename = "IPDO-#{day}-#{month}-#{year}.pdf"
  link = URI.escape("http://www.ons.org.br/publicacao/ipdo/Ano_#{year}/Mês_#{month}/#{filename}")
  return [filename, link]
end

def wait_for_ipdo(date)
  url = ipdo_file_name(date)[1]
  uri = URI.parse(url)
  result = Net::HTTP.start(uri.host, uri.port) { |http| http.get(uri.path) }
  code = result.code.to_i
  puts "code: #{code}, date: #{date}, #{Time.now}, will enter loop if 404"
  while code != 200
    sleep(60)
    result = Net::HTTP.start(uri.host, uri.port) { |http| http.get(uri.path) }
    code = result.code.to_i
    puts "code: #{code}, date: #{date}, #{Time.now}, inside loop"
  end

  #download
  Net::HTTP.start("www.ons.org.br") { |http|
    resp = http.get(url)
    open('#{File.expand_path File.dirname(__FILE__)}/data/send/ipdo.pdf', "wb") { |file|
      file.write(resp.body)
     }
  }

  #send to slack
  send_ipdo_to_slack ipdo_file_name(date)[0]
end
