require 'sinatra'
require 'yajl'
require 'eventmachine'
require 'stringio'

require_relative 'pinger'
$stderr.reopen("/var/log/pinger_error.log", "w")
$stderr.sync = true
$total_sent = 0
$total_lost = 0
$total_average = 0



get '/pinger' do
  begin
    pinger.values.to_json
  rescue StandardError => e
    STDERR.puts("Unhandled Exception' #{e}\n #{e.backtrace}")
    e.to_json
  end
end

get '/history' do
  {'sent' => $total_sent, 
   'lost' => $total_lost,
   'avg' => $total_avg
  }.to_json
end

class Application < Sinatra::Base
  set :sessions, true
  set :logging, false
  set :run, true
  set :timeout, 290

  $pinger ||= Pinger.instance(60, '8.8.8.8', 5)
  $pinger.start_pinger

  server.threaded = settings.threaded if server.respond_to? :threaded=

end

def pinger
  $pinger ||= Pinger.instance(60, '8.8.8.8', 6)

end

