require_relative 'lib/bundler'

ENV["SLACK_BOT_KEY"]="xoxb-198073611270-MvuoKvrxU6yMOu0qzUQZAW1c"

def main
  run_mapas
  run_ipdo
  update_www
  ten_day
end

main
