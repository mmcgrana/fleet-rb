require "test/unit"
require "lib/fleet"

class FleetTest < Test::Unit::TestCase
  def setup
    @client = Fleet.new
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
    assert_raise RuntimeError do
      @client.query(["bogus"])
    end
  end

  def teardown
    @client.close
  end
end
