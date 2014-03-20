module Cassmap
  class Base
    include ActiveModel::Model

    def method_missing(m, *args, &block)
      method_symbol = m.to_sym
      if self.class.columns.include?(method_symbol)
        @attributes[method_symbol]
      elsif m[-1] == "=" #FIXME needs to check against columns
      key = m[0..-2] #strip equals
        @attributes[key.to_sym] = args[0]
      else
        super(m)
      end
    end

    #FIXME naieve
    def respond_to?(method, include_private =false )
      super || self.respond_to?(method, include_private)
    end

    def self.columns
      column_metadata = initialize_columns(self.class.model_name.plural)
      @@columns ||= column_metadata.column_names
    end

  end
end
