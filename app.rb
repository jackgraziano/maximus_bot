require_relative 'lib/bundler'
require('dotenv').config()

def main
  run_mapas
  run_ipdo
  update_www
end

main
