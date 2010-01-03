require "socket"
require "yajl"

class Fleet
  def initialize(options = {})
    @host = options[:host] || "127.0.0.1"
    @port = options[:port] || 3400
    @socket = TCPSocket.new(@host, @port)
    @json_encoder = Yajl::Encoder
    @json_parser  = Yajl::Parser
  end

  def query(q)
    request = @json_encoder.encode(q)
    @socket.write(request)
    @socket.write("\r\n")
    response = @socket.gets
    status, value = @json_parser.parse(response)
    status == 0 ? value : raise(value)
  end

  def close
    @socket.close
  end

  def to_s
    "FleetDB client connected to #{@host}:#{@port}"
  end
end
