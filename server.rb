begin
  require 'sinatra'
  require 'yajl'

  require 'stringio'

  require_relative 'pinger'
  $stderr.reopen("/var/log/pinger_error.log", "w")
  $stderr.sync = true


  STDERR.puts("Got #{pinger}")
  pinger.start_pinger
  
  get '/pinger' do
         begin
           {
             'period' => pinger.period,
             'sent' => pinger.sent,
             'lost' => pinger.lost,
             'rtt' => {
             'avg' => pinger.rtt_avg,
             'min' => pinger.rtt_min,
             'max' => pinger.rtt_max,
             }
           }.to_json
     
         rescue StandardError => e
           STDERR.puts('Unhandled Exception' + e.to_s + '\n' + e.backtrace.to_s )
           e.to_json
         end
       end
  def  pinger 
    @pinger ||= Pinger.instance(60, '8.8.8.8', 5)
    
  end
  end     
  
  class Application < Sinatra::Base
    set :sessions, true
    set :logging, false
    set :run, true
    set :timeout, 290


    server.threaded = settings.threaded if server.respond_to? :threaded=
 
   
  end
  
  def  pinger 
    @pinger ||= Pinger.instance(60, '8.8.8.8', 5)
    
  end

