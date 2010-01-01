# fleet-rb

A Ruby client for FleetDB.

## Setup

Install and start FleetDB as described in the [FleetDB getting started guide](http://fleetdb.org/docs/getting_started.html), then install this client library with:

    $ sudo gem install fleet

## Usage
    
    require "rubygems"
    require "fleet"
    
    client = Fleet.new("127.0.0.1", 3400)
    
    client.query(["ping"])
    #=> "pong"
    
    client.query(["select", "accounts", {"where" => ["=", "id", 2]}])
    #=> [{"id" => 2, "owner" => "Alice", "credits" => 150}]

The client will raise an exception in the case of an error:

    => (c/query client ["bogus"])
    java.lang.Exception: Malformed query: unrecognized query type '"bogus"'

See the [FleetDB getting started guide](http://fleetdb.org/docs/getting_started.html) and the [FleetDB query reference](http://fleetdb.org/docs/queries.html) for documentation on the queries available to clients.