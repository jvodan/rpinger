require 'yajl/json_gem'

begin
  require 'sinatra'
  require 'yajl'
  require 'ffi_yajl'

  require 'stringio'

  require_relative 'pinger'

  $stderr.sync = true

  @pinger = Pinger.new

  class Application < Sinatra::Base
    #  set :sessions, true
    set :logging, false
    set :run, true
    set :timeout, 290


    server.threaded = settings.threaded if server.respond_to? :threaded=

    get '/' do
      begin
        content-type
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
      end
    end

  rescue StandardError => e
    STDERR.puts('Unhandled Exception' + e.to_s + '\n' + e.backtrace.to_s )
    e.to_json
  end

end
