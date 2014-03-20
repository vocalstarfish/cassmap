module Cassmap
  class Config
    cattr_accessor :keyspace, :replication, :security, :hosts
  end
end
