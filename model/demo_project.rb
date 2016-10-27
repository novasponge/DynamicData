require_relative '../lib/associatable_advanced'

class Task < SQLObject
  belongs_to :list
  has_one_through :user, :list, :user
end

Task.finalize!

class List < SQLObject
  has_many :tasks
  belongs_to :user,
    foreign_key: :author_id
end

List.finalize!

class User < SQLObject
  has_many :lists,
    foreign_key: :author_id
end

User.finalize!
