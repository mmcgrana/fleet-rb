require "socket"
require "yajl"

class Fleet
  def initialize(host, port)
    @host = host
    @port = port
    @socket = TCPSocket.new(host, port)
  end

  def query(q)
    request = Yajl::Encoder.encode(q)
    @socket.write(request)
    @socket.write("\r\n")
    response = @socket.gets
    status, value = Yajl::Parser.parse(response)
    status == 0 ? value : raise(value)
  end

  def close
    @socket.close
  end

  def to_s
    "FleetDB client connected to #{@host}:#{@port}"
  end
end
