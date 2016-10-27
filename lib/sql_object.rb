require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    if @col_names.nil?
      names = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          #{table_name}
        LIMIT
          0
      SQL
      @col_names = names.first.map { |col| col.to_sym }
    else
      @col_names
    end
  end

  def self.finalize!
    columns.each do |col|
      define_method(col) do
        attributes[col]
      end

      define_method(col.to_s + '=') do |arg|
        attributes[col] = arg
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    if @table_name.nil?
      self.to_s.downcase + "s"
    else
      @table_name
    end
  end

  def self.all
    result = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    parse_all(result)
  end

  def self.parse_all(results)
    obj_results = []
    results.each do |result|
      obj_results << self.new(result)
    end
    obj_results
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{table_name}.id = ?
    SQL
    parse_all(result).first
  end

  def initialize(params = {})
    params.each do |k ,v|
      raise "unknown attribute '#{k}'" unless self.class.columns.include?(k.to_sym)
      self.send("#{k}=", v)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |k| self.send(k)}
  end

  def insert
    col_names = self.class.columns[1..-1]
    question_marks = (["?"] * col_names.length).join(", ")
    DBConnection.execute(<<-SQL, *attribute_values[1..-1])
      INSERT INTO
        #{self.class.table_name} (#{col_names.join(", ")})
      VALUES
        (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    col_names = self.class.columns[1..-1].map{|k|k.to_s}
    question_marks = ([" = ?"] * col_names.length)
    set = (col_names.zip(question_marks)).map {|pair| pair[0] + pair[1] }.join(", ")
    DBConnection.execute(<<-SQL, *attribute_values[1..-1], attribute_values[0])
      UPDATE
        #{self.class.table_name}
      SET
        #{set}
      WHERE
        id = ?
    SQL
  end

  def destroy
    DBConnection.execute(<<-SQL, attribute_values[0])
    DELETE FROM
      #{self.class.table_name}
    WHERE
      id = ?
    SQL
  end

  def save
    if attribute_values[0].nil?
      insert
    else
      update
    end
  end
end
