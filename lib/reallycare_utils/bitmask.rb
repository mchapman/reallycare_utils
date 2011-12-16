module ReallycareUtils
  module Bitmask
    module ClassMethods
      def has_bitmasks(types)
        types.each do |attribute, values|
          values.each_with_index do |value_name, i|
            
            define_method("add_#{attribute}_#{value_name}".to_sym) do |save_it=false|
              self["#{attribute}"] = (self["#{attribute}"] || 0) | (2 ** i)
              self.save! if save_it
            end
            
            define_method("remove_#{attribute}_#{value_name}".to_sym) do |save_it=false|
              self["#{attribute}"] = (self["#{attribute}"] || 0) & ~(2 ** i)
              self.save! if save_it
            end
            
            define_method("has_#{attribute}_#{value_name}?".to_sym) do
              (self["#{attribute}"][i] || 0) != 0
            end
          end

          define_method("show_#{attribute}_flags".to_sym) do
            val = self["#{attribute}"] || 0
            values.map.with_index { |value_name, i| value_name if val[i] == 1 }.compact
          end
        end
      end
    end
    
    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
end


