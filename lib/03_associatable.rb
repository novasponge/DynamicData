require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    # ...
    Object.const_get(class_name)
  end

  def table_name
    # ...
    class_name.downcase + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    # ...
    @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || "#{name.capitalize}"
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    # ...
    key = self_class_name.downcase
    @foreign_key = options[:foreign_key] || "#{key}_id".to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || "#{name.capitalize[0..-2]}"
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    # ...
    option = BelongsToOptions.new(name, options)
    define_method(name) do
      key_val = self.send(option.foreign_key)
      option
        .model_class
        .where(option.primary_key => key_val)
        .first
    end
    assoc_options[name] = option
  end

  def has_many(name, options = {})
    # ...
    option = HasManyOptions.new(name, self.name, options)
    define_method(name) do
      key_val = self.send(option.primary_key)
      option
        .model_class
        .where(option.foreign_key => key_val)
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
    @assoc_options ||= {}
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
