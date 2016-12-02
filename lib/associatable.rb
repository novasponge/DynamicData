require_relative 'searchable'
require 'active_support/inflector'
require_relative 'attr_accessor_teaser'

class AssocOptions < AttrAccessorObject
  my_attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    Object.const_get(class_name)
  end

  def table_name

    class_name.downcase + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || "#{name.capitalize}"
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    key = self_class_name.downcase
    @foreign_key = options[:foreign_key] || "#{key}_id".to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || "#{name.capitalize[0..-2]}"
  end
end

module Associatable
  def belongs_to(name, options = {})
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
    option = HasManyOptions.new(name, self.name, options)
    define_method(name) do
      key_val = self.send(option.primary_key)
      option
        .model_class
        .where(option.foreign_key => key_val)
    end
  end

  def has_one_through(name, through_name, source_name)
    # ...
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.table_name
      through_pk = through_options.primary_key
      through_fk = through_options.foreign_key

      source_table = source_options.table_name
      source_pk = source_options.primary_key
      source_fk = source_options.foreign_key

      key_val = self.send(through_fk)

      results = DBConnection.execute(<<-SQL, key_val)
        SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table}
        ON
          #{through_table}.#{source_fk} = #{source_table}.#{source_pk}
        WHERE
          #{through_table}.#{through_pk} = ?
      SQL

      source_options.model_class.parse_all(results).first

    end
  end
  
  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
