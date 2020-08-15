
  require 'sinatra'
  require 'yajl'
require 'eventmachine'
  require 'stringio'

  require_relative 'pinger'
  $stderr.reopen("/var/log/pinger_error.log", "w")
  $stderr.sync = true

  
  get '/pinger' do
    STDERR.puts("Got #{pinger}")
         begin
           STDERR.puts("#{values}")    
         values     
         rescue StandardError => e
           STDERR.puts("Unhandled Exception' #{e}\n #{e.backtrace}")
           e.to_json
         end
       end  
  
  class Application < Sinatra::Base
    set :sessions, true
    set :logging, false
    set :run, true
    set :timeout, 290
    
    $pinger ||= Pinger.instance(60, '8.8.8.8', 5)
  
    STDERR.puts("Got #{$pinger}")
    $pinger.start_pinger

    server.threaded = settings.threaded if server.respond_to? :threaded=
 
   
  end
  
def values
  {
    'period' => $period,
    'sent' => $sent,
    'lost' => $lost,
    'rtt' => {
    'avg' => $rtt_avg.to_i,
    'min' => $rtt_min.to_i,
    'max' => $rtt_max.to_i,
    'count' => $count
    }
  }.to_json
end

  def pinger 
    $pinger ||= Pinger.instance(60, '8.8.8.8', 6)
    
  end

