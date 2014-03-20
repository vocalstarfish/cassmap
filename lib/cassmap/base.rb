module Cassmap
  class Base
    include ActiveModel::Model
    extend ActiveModel::Naming

    cattr_accessor :columns

    def initialize attributes = {}
      @attributes = attributes
    end

    def method_missing(m, *args, &block)
      if includes_column_named? m
        @attributes[m.to_sym]
      elsif m[-1] == "="
        key = m[0..-2] #strip equals
        if includes_column_named? key
          @attributes[key.to_sym] = args[0]
        else
          super(m) #FIXME hack
        end
      else
        super(m)
      end
    end

    def respond_to_missing?(method, include_private =false )
      includes_column_named?(method)|| super
    end

    def includes_column_named? column_name
      self.class.columns.include?(column_name.to_sym)
    end

    def self.columns
      column_metadata = initialize_columns(self.model_name.plural)
      @@columns ||= column_metadata.column_names
    end

    def self.initialize_columns table_name
      #FIXME save me off for optimization
      prepared =  Cassmap::Cql.prepare <<CQLCOL
        SELECT column_name FROM system.schema_columns
        WHERE keyspace_name = ?
        AND columnfamily_name = ?
CQLCOL
      keyspace = Cassmap::Config.keyspace
      rows = prepared.execute(keyspace,table_name)
      column_names = rows.map { |row| row["column_name"].to_sym }
      require 'ostruct'
      OpenStruct.new(
        column_names: column_names
      )
    end

  end
end
