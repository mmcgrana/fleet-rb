require "socket"
require "yajl"
require "system_timer"


class Fleet
  def initialize(options = {})
    @host =     options[:host] || "127.0.0.1"
    @port =     options[:port] || 3400
    @timeout =  options[:timeout] || 5
    @password = options[:password]
    @json_encoder = Yajl::Encoder
    @json_parser  = Yajl::Parser
    connect
  end

  def query(q)
    request = @json_encoder.encode(q)
    response = write_and_read_with_retry(request)
    status, value = @json_parser.parse(response)
    status == 0 ? value : raise(value)
  end

  def close
    disconnect
  end

  def to_s
    "FleetDB client connected to #{@host}:#{@port}"
  end

  private

  def connect
    @socket =
      with_timeout do
        socket = TCPSocket.new(@host, @port)
        socket.setsockopt Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1
        socket
      end
  end

  def disconnect
    @socket.close rescue nil
    @socket = nil
  end

  def write_and_read_with_retry(request)
    begin
      write_and_read(request)
    rescue Errno::ECONNRESET, Errno::EPIPE, Errno::ECONNABORTED, Timeout::Error
      disconnect
      connect
      write_and_read(request)
    end
  end

  def write_and_read(request)
    with_timeout do
      @socket.write(request)
      @socket.write("\r\n")
      @socket.gets
    end
  end

  def with_timeout
    if @timeout == 0
      yield
    else
      SystemTimer.timeout_after(@timeout) { yield }
    end
  end
end
