require 'byebug'

class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      name = name.to_s
      define_method(name) do
        instance_variable_get("@#{name}")
      end

      name_ = name + '='
      define_method(name_) do |arg = nil|
        instance_variable_set("@#{name}", arg)
      end
    end
  end
end
