begin
  require 'sinatra'
  require 'yajl'

  require 'stringio'

  require_relative 'pinger'

  $stderr.sync = true

  get '/' do
       begin
         {
           'period' => @pinger.period,
           'sent' => @pinger.sent,
           'lost' => @pinger.lost,
           'rtt' => {
           'avg' => @pinger.rtt_avg,
           'min' => @pinger.rtt_min,
           'max' => @pinger.rtt_max,
           }
         }.to_json
   
       rescue StandardError => e
         STDERR.puts('Unhandled Exception' + e.to_s + '\n' + e.backtrace.to_s )
         e.to_json
       end
     end

     def pinger
       @pinger ||= Pinger.new('8.8.8.8')
     end

  class Application < Sinatra::Base
    #  set :sessions, true
    set :logging, false
    set :run, true
    set :timeout, 290
    
    STDERR.puts("Got #{@pinger}")
    server.threaded = settings.threaded if server.respond_to? :threaded=

   
  end
end
