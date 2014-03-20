require 'cql'

module Cassmap
  module Cql

    def self.execute cql
      CqlSingleton.instance.execute cql
    end

    def self.prepare cql
      CqlSingleton.instance.prepare cql
    end

    def self.shutdown
      CqlSingleton.instance.shutdown
    end

  end

  class CqlSingleton
    include Singleton

    def initialize
      #FIXME look for configuration here
      @cql = ::Cql::Client.connect
    end

    def shutdown
      cql.shutdown
    end

    def execute cql_string
      cql.execute cql_string
    end

    def prepare cql_string
      cql.prepare cql_string
    end

    private
    attr_accessor :cql
  end
end


