include Magick

def clean_maps
  FileUtils.rm_rf(Dir.glob('data/mapas/eta/*'))
  FileUtils.rm_rf(Dir.glob('data/mapas/global/*'))
end

def download_eta
  (1..10).each do |n|
    url = "/images/operacao_integrada/meteorologia/eta/shad50_#{n}.gif"
    Net::HTTP.start("www.ons.org.br") { |http|
      resp = http.get(url)
      open("data/mapas/eta/shad50_#{n.to_s.rjust(2,"0")}.gif", "wb") { |file|
        file.write(resp.body)
       }
    }
  end
end

def make_gifs
  animation = ImageList.new(
                            "#{Dir.pwd}/data/mapas/eta/shad50_01.gif",
                            "#{Dir.pwd}/data/mapas/eta/shad50_02.gif",
                            "#{Dir.pwd}/data/mapas/eta/shad50_03.gif",
                            "#{Dir.pwd}/data/mapas/eta/shad50_04.gif",
                            "#{Dir.pwd}/data/mapas/eta/shad50_05.gif",
                            "#{Dir.pwd}/data/mapas/eta/shad50_06.gif",
                            "#{Dir.pwd}/data/mapas/eta/shad50_07.gif",
                            "#{Dir.pwd}/data/mapas/eta/shad50_08.gif",
                            "#{Dir.pwd}/data/mapas/eta/shad50_09.gif",
                            "#{Dir.pwd}/data/mapas/eta/shad50_10.gif",
                            )
  animation.delay = 100
  animation.iterations = 0
  animation.write("#{Dir.pwd}/data/send/gif_eta.gif")

  animation = ImageList.new(
                            "#{Dir.pwd}/data/mapas/global/glob50_01.gif",
                            "#{Dir.pwd}/data/mapas/global/glob50_02.gif",
                            "#{Dir.pwd}/data/mapas/global/glob50_03.gif",
                            "#{Dir.pwd}/data/mapas/global/glob50_04.gif",
                            "#{Dir.pwd}/data/mapas/global/glob50_05.gif",
                            "#{Dir.pwd}/data/mapas/global/glob50_06.gif",
                            "#{Dir.pwd}/data/mapas/global/glob50_07.gif",
                            "#{Dir.pwd}/data/mapas/global/glob50_08.gif",
                            "#{Dir.pwd}/data/mapas/global/glob50_09.gif",
                            "#{Dir.pwd}/data/mapas/global/glob50_10.gif",
                            )
  animation.delay = 100
  animation.iterations = 0
  animation.write("#{Dir.pwd}/data/send/gif_global.gif")
end

def download_gefs
  (1..10).each do |n|
    url = "/images/operacao_integrada/meteorologia/global/glob50_#{n}.gif"
    Net::HTTP.start("www.ons.org.br") { |http|
      resp = http.get(url)
      open("data/mapas/global/glob50_#{n.to_s.rjust(2,"0")}.gif", "wb") { |file|
        file.write(resp.body)
       }
    }
  end
end

def make_pdf
  pdf = WickedPdf.new.pdf_from_html_file("#{Dir.pwd}/data/mapas/mapas.html", orientation: 'Landscape')
  File.open('data/send/mapas.pdf', 'wb') do |file|
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
