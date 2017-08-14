require 'httparty'

def download_ten_day
  src = "http://wxmaps.org/pix/prec8.png"
  dest = "/home/maxima/network/downloads/10day_prec/ten_day_#{DateTime.now.strftime("%Y%m%d_%H_%m")}.png"
  File.open(dest, "wb") { |f| f.write HTTParty.get(src).body } #download
  return dest
end

def downloads
  src = "http://www.ons.org.br/images/operacao_integrada/meteorologia/global/GEFS_precipitacao10d.zip"
  dest = "/home/maxima/network/downloads/gefs_num/gefs_#{DateTime.now.strftime("%Y%m%d_%H_%m")}.zip"
  File.open(dest, "wb") { |f| f.write HTTParty.get(src).body } #download

  src = "http://www.ons.org.br/images/operacao_integrada/meteorologia/eta/Eta40_precipitacao10d.zip"
  dest = "/home/maxima/network/downloads/eta_num/eta_#{DateTime.now.strftime("%Y%m%d_%H_%m")}.zip"
  File.open(dest, "wb") { |f| f.write HTTParty.get(src).body } #download
end

def ten_day
  downloads
  file = download_ten_day
  send_ten_day_slack(file)
end

