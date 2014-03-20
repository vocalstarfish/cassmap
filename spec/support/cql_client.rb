require 'cql'

RSpec.configure do |config|
  config.before(:all) do
    cql_connect
  end
  config.after(:all) do
    cql_shutdown
  end
end

class CqlSingleton
  include Singleton

  attr_reader :client

  def connect
    @client = Cql::Client.connect hosts: Cassmap::Config.hosts
  end

  def shutdown
    @client.close
  end

end

module CqlClient
  def cql
    CqlSingleton.instance.client
  end

  def cql_shutdown
    CqlSingleton.instance.shutdown
  end

  def cql_connect
    CqlSingleton.instance.connect
  end
end

include CqlClient
