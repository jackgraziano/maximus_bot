include Magick

def clean_maps
  FileUtils.rm_rf(Dir.glob('mapas/eta/*'))
  FileUtils.rm_rf(Dir.glob('mapas/global/*'))
end

def download_eta
  (1..10).each do |n|
    url = "/images/operacao_integrada/meteorologia/eta/shad50_#{n}.gif"
    Net::HTTP.start("www.ons.org.br") { |http|
      resp = http.get(url)
      open("mapas/eta/shad50_#{n.to_s.rjust(2,"0")}.gif", "wb") { |file|
        file.write(resp.body)
       }
    }
  end
end

def gif
  animation = ImageList.new(
                            "mapas/eta/shad50_01.gif",
                            "mapas/eta/shad50_02.gif",
                            "mapas/eta/shad50_03.gif",
                            "mapas/eta/shad50_04.gif",
                            "mapas/eta/shad50_05.gif",
                            "mapas/eta/shad50_06.gif",
                            "mapas/eta/shad50_07.gif",
                            "mapas/eta/shad50_08.gif",
                            "mapas/eta/shad50_09.gif",
                            "mapas/eta/shad50_10.gif",
                            )
  animation.delay = 100
  animation.iterations = 0
  animation.write("mapas/eta/gif_eta.gif")
end

def download_gefs
  (1..10).each do |n|
    url = "/images/operacao_integrada/meteorologia/global/glob50_#{n}.gif"
    Net::HTTP.start("www.ons.org.br") { |http|
      resp = http.get(url)
      open("mapas/global/glob50_#{n.to_s.rjust(2,"0")}.gif", "wb") { |file|
        file.write(resp.body)
       }
    }
  end
end

def run_mapas
  clean_maps
  download_eta
  download_gefs
  gif
end

run_mapas
