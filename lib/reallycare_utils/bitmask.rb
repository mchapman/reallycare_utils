module ReallycareUtils
  module Bitmask
    module ClassMethods
      def has_bitmask(field, statuses)
        @@has_bitmask_field = field
        @@has_bitmask_values = statuses
        
        define_bitmask_methods
      end
      
      def bitmask_value(status_const)
        return 2**@@has_bitmask_values.index(status_const.to_sym)
      end
      
      def define_bitmask_methods
        define_method "has_#{@@has_bitmask_field}?" do |bitmask_const|
          if self[@@has_bitmask_field]
            if bitmask_const.instance_of? Fixnum
              this_bit = bitmask_const
            else
              this_bit = self.class.bitmask_value(bitmask_const)
            end
            has_it = (self[@@has_bitmask_field] & this_bit > 0)
          else
            has_it = false
          end
          has_it
        end
        
        define_method "add_#{@@has_bitmask_field}" do |bitmask_const, save_it=false|
          self[@@has_bitmask_field] = (self[@@has_bitmask_field] || 0) | self.class.bitmask_value(bitmask_const)
          self.save! if save_it
        end
        
        define_method "remove_#{@@has_bitmask_field}" do |bitmask_const, save_it=false|
          self[@@has_bitmask_field] = (self[@@has_bitmask_field] || 0) & ~(self.class.bitmask_value(bitmask_const))
          self.save! if save_it
        end
          
      end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      # receiver.send :include, InstanceMethods
    end
  end
end
