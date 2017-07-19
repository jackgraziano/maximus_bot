include Magick

def clean_maps
  FileUtils.rm_rf(Dir.glob('#{File.expand_path File.dirname(__FILE__)}/data/mapas/eta/*'))
  FileUtils.rm_rf(Dir.glob('#{File.expand_path File.dirname(__FILE__)}/data/mapas/global/*'))
end

def download_eta
  (1..10).each do |n|
    url = "/images/operacao_integrada/meteorologia/eta/shad50_#{n}.gif"
    Net::HTTP.start("www.ons.org.br") { |http|
      resp = http.get(url)
      open("#{File.expand_path File.dirname(__FILE__)}/data/mapas/eta/shad50_#{n.to_s.rjust(2,"0")}.gif", "wb") { |file|
        file.write(resp.body)
       }
    }
  end
end

def make_gifs
  animation = ImageList.new(
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/eta/shad50_01.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/eta/shad50_02.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/eta/shad50_03.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/eta/shad50_04.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/eta/shad50_05.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/eta/shad50_06.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/eta/shad50_07.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/eta/shad50_08.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/eta/shad50_09.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/eta/shad50_10.gif",
                            )
  animation.delay = 100
  animation.iterations = 0
  animation.write("#{File.expand_path File.dirname(__FILE__)}/data/send/gif_eta.gif")

  animation = ImageList.new(
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/global/glob50_01.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/global/glob50_02.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/global/glob50_03.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/global/glob50_04.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/global/glob50_05.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/global/glob50_06.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/global/glob50_07.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/global/glob50_08.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/global/glob50_09.gif",
                            "#{File.expand_path File.dirname(__FILE__)}/data/mapas/global/glob50_10.gif",
                            )
  animation.delay = 100
  animation.iterations = 0
  animation.write("#{File.expand_path File.dirname(__FILE__)}/data/send/gif_global.gif")
end

def download_gefs
  (1..10).each do |n|
    url = "/images/operacao_integrada/meteorologia/global/glob50_#{n}.gif"
    Net::HTTP.start("www.ons.org.br") { |http|
      resp = http.get(url)
      open("#{File.expand_path File.dirname(__FILE__)}/data/mapas/global/glob50_#{n.to_s.rjust(2,"0")}.gif", "wb") { |file|
        file.write(resp.body)
       }
    }
  end
end

def make_pdf
  pdf = WickedPdf.new.pdf_from_html_file("#{File.expand_path File.dirname(__FILE__)}/data/mapas/mapas.html", orientation: 'Landscape')
  File.open("#{File.expand_path File.dirname(__FILE__)}/data/send/mapas.pdf", 'wb') do |file|
    file << pdf
  end
end

def run_mapas
  clean_maps
  download_eta
  download_gefs
  make_gifs
  make_pdf
  send_maps_to_slack "mapas_#{Date.today.strftime("%d-%m-%Y")}.pdf"
end
