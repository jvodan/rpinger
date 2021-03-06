class Pinger
  class << self
    def instance(p = 60, h = '8.8.8.8', c = 5)
      @@instance ||= self.new(p , h , c )
    end
  end

  require 'eventmachine'
  require 'net/ping'
  attr_accessor :period,:count,:host,:rtt_max,:rtt_min,:rtt_avg,:sent,:lost

  def initialize(p = 60, h = '8.8.8.8', c = 5)
    if File.exist?('conf/config.yaml')
      config_file = File.open('conf/config.yaml','r')
      config = YAML::load(config_file)
      unless config.nil?
        STDERR.puts("loaded config as #{config}")
        @period = config['period']
        @count = config['count']
        @host = config['host']
        @name  = config['label']
      end
    else
      @period = p
      @count = c
      @host = h
      @name  = ''
    end
    STDERR.puts("Pinger #{@host} #{@count} times every #{@period} seconds")
    @sent = 0
    @lost = 0
    @total_avg =  0
    @total_sent = 0
    @total_lost = 0
  end

  def net_pinger
    @net_pinger ||= Net::Ping::ICMP.new(@host) #Net::Ping(@host, nil, timeout = 5)
  end

  def start_pinger
    @pinger_thread = Thread.new {run_pinger}
  end

  def do_pings
    sent = 0
    lost = 0
    max = 0
    total =0
    min = 99999
    while sent < @count do
      begin
        r = net_pinger.ping(@host)
        sent += 1
        min = r if r < min
        max = r if r > max
        total += r
      rescue  StandardError =>e #FIX ME why if DNS or no route ro hose
        STDERR.puts("#{e}")
        lost += 1
        sent += 1
      end
    end
    @rtt_max = max * 1000
    @rtt_min = min * 1000
    @rtt_avg = total / (sent - lost) * 1000
    @sent = sent
    @lost = lost
    n = ($total_sent - $total_lost) / @count
    @total_avg = (($total_avg *  n + @rtt_avg ) / (n + 1)).to_i
    @total_sent += sent
    @total_lost += lost
  end

  def run_pinger

    ping_mutex.synchronize {
      timer = EventMachine::PeriodicTimer.new(@period) do
        do_pings
      end
    }
  end

  def ping_mutex
    @ping_mutex ||= Mutex.new
  end

  def history
   [ {
      'label' => @name,
      'host' => @host,    
      'sent' => @total_sent,
      'lost' => @total_lost,
      'avg' => @total_avg
    }]
  end

  def values
   [ {
      'label' => @name,
      'host' => @host,    
      'period' => @period,
      'sent' => @sent,
      'lost' => @lost,
      'rtt' => {
      'avg' => @rtt_avg.to_i,
      'min' => @rtt_min.to_i,
      'max' => @rtt_max.to_i
      }
    } ]

  end
end