require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    search_condition = params.keys.map{ |k| k.to_s + "= ?" }.join("AND ")
    results = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{search_condition}
    SQL
    parse_all(results)
  end
end

class SQLObject
  extend Searchable
end
