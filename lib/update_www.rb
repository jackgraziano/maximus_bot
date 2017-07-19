#update www
require 'open-uri'
require 'nokogiri'
require 'httparty'

def update_www
  # Consumo to SNE
  url_consumo = "http://www.ons.org.br/home/grafico.asp"
  doc_consumo = Nokogiri::HTML(open(url_consumo))
  consumo = { load: doc_consumo.css("b").children.text.split(" ")[0].to_f,
              date: doc_consumo.css("#data").text.split(" ")[1]}
  @urlstring_to_post = "http://www.maximacomercializadora.com/api/v1/loads"
  @result = HTTParty.post(@urlstring_to_post.to_str,
      :body => {load: consumo}.to_json,
      :headers => { 'Content-Type' => 'application/json' } )
  puts @result

  # Nivel dos reservatorios
  url_reserva = "http://www.ons.org.br/home/reservatorio.asp"
  doc_reserva = Nokogiri::HTML(open(url_reserva)).xpath('//table/tr')
  reservas = {}
  (2..5).each do |n|
    reservas[doc_reserva.xpath("//tr[#{n}]/td[1]").text] =  doc_reserva.xpath("//tr[#{n}]/td[2]").text.delete('%').gsub(',','.')
  end
  reservas[:date] = Date.today - 1

  reservas["SE"] = reservas["SE/CO"] && reservas.delete("SE/CO") if reservas.key? "SE/CO"
  reservas["NO"] = reservas["N"] && reservas.delete("N") if reservas.key? "N"

  @urlstring_to_post = "http://www.maximacomercializadora.com/api/v1/reservoirs"
  @result = HTTParty.post(@urlstring_to_post.to_str,
      :body => {reservoir: reservas}.to_json,
      :headers => { 'Content-Type' => 'application/json' } )
end
