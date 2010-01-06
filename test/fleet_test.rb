require "test/unit"
require "lib/fleet"

# fleetdb-server -e -p 3400
# fleetdb-server -e -p 3401 -x pass

class FleetTest < Test::Unit::TestCase
  def setup
    @client = Fleet.new(:port => 3400, :timeout => 1)
    @client.query(["delete", "records"])
  end

  def test_ping
    assert_equal("pong", @client.query(["ping"]))
  end

  def test_write_read
    assert_equal(1, @client.query(["insert", "records", {"id" => 3}]))
    assert_equal([{"id" => 3}], @client.query(["select", "records"]))
  end

  def test_exception
    assert_raise Fleet::ClientError do
      @client.query(["bogus"])
    end
  end

  def test_conn_refused
    assert_raise Errno::ECONNREFUSED do
      Fleet.new(:port => 3402)
    end
  end

  def test_query_timeout
    server = TCPServer.open(3402)
    f = Fleet.new(:port => 3402, :timeout => 1)
    assert_raise Timeout::Error do
      f.query(["ping"])
    end
    server.close
  end

  def test_client_auth_success
    client = Fleet.new(:port => 3401, :timeout => 1, :password => "pass")
    assert_equal "pong", @client.query(["ping"])
  end

  def test_client_auth_ommission
    assert_raises Fleet::ClientError do
      client = Fleet.new(:port => 3401, :timeout => 1)
      client.query(["ping"])
    end
  end

  def test_client_auth_failure
    assert_raises Fleet::ClientError do
      Fleet.new(:port => 3401, :timeout => 1, :password => "notpass")
    end
  end

  def teardown
    @client.close
  end
end
