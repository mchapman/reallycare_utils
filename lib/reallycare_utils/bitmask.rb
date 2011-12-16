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
              ((self["#{attribute}"] || 0 )[i]) != 0
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

if __FILE__ == $0

  class FakeActiveRecord
    def [](value)
      instance_variable_get(('@'+value).to_sym)
    end

    def []=(value, value2)
      instance_variable_set(('@'+value).to_sym, value2)
    end
  end

  class User < FakeActiveRecord
    include ReallycareUtils::Bitmask

    has_bitmasks :status => [:verified, :locked_out], :role => [:admin, :staff]
  end

  class Angel < FakeActiveRecord
    include ReallycareUtils::Bitmask
    has_bitmasks :status => [:pending, :approved]
  end

  if __FILE__ == $0
    u = User.new
    u.add_status_verified
    puts "#{u.has_role_staff?} should be false" if u.has_role_staff?
    u.add_role_staff
    puts "#{u.show_role_flags} should be staff" unless u.show_role_flags == [:staff]
    puts "#{u.show_status_flags} should be verified" unless u.show_status_flags == [:verified]
    puts "#{u.has_status_verified?} should be true" unless u.has_status_verified?
    puts "#{u.has_status_locked_out?} should be false" if u.has_status_locked_out?
    u.add_status_locked_out
    puts "#{u.show_status_flags} should be verified and locked_out" unless u.show_status_flags == [:verified, :locked_out]
    u.remove_status_verified
    puts "#{u.show_status_flags} should be locked_out" unless u.show_status_flags == [:locked_out]
    a = Angel.new
    a.add_status_pending
    puts "#{a.show_status_flags} should be pending" unless a.show_status_flags == [:pending]
    puts "Success!"
  end  
end
