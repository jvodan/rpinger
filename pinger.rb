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
        sent = 0
        lost = 0
        max = 0
        total =0
        min = 99999
        while count < @count
          begin
            r = @net_pinger.ping(@host)
            sent += 1
            min = r if r < min
            max = r if r > max
            total += r
            STDERR.puts("pinger got #{r}")
          rescue
            lost += 1
          end
        end
        @rtt_max = max
        @rtt_min = min
        @rtt_avg = total / @count
        @sent = sent
        @lost = lost
      end
    end

  end
end