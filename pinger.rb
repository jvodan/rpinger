class Pinger
  require 'eventmachine'
  require 'net/ping'
  attr_accessor :period,:count,:host,:rtt_max,:rtt_min,:rtt_avg,:sent,:lost
  
  def initialize(p = 300, h = '10.26.30.92', c = 5)
    @period = p
    @count = 5
    @host = h
    @rtt_max = 0
    @rtt_min = 0
    @rtt_avg = 0
    @sent = 0
    @lost = 0
    @net_pinger = Net::Ping::ICMP.new(@host) #Net::Ping(@host, nil, timeout = 5)
  end

  def start_pinger
    @pinger_thread = Thread.new {pinger}
  end

  def pinger
    EM.run do
    timer = EventMachine::PeriodicTimer.new(@period) do
      r = @net_pinger.ping(@host)
      STDERR.puts("pinger got #{r}")
    end
    end

  end
end