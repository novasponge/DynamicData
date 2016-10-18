# DynamicData

DynamicData is a lightweight SQLite3 ORM.

### Dynamic method creation for database interface

```ruby
# Ruby class representation of SQL table
class Task < SQLObject
end

# Retrieve column names, creating setter and getter instance methods for each column
Task.finalize!
```

### Ruby-wrapped record objects

```ruby
# Retrieve records
user = User.where(name: 'Harles Richey')
list = List.where(name: 'Doctor appointment')

# Set record attribute
list.author_id = user.idea

# Save record
list.save

# Create new record object
new_list = List.new(name: 'Monday todos', author_id: user.id )

# Save new record
new_list.save
```
### Association methods
```ruby
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
```
## Retrieve record
```ruby
users = User.all
#[#<User:0x007fa6fd820360 @attributes={:id=>1, :username=>"Aaron Grau", :email=>"Aroan@aol.com"}>,
#<User:0x007fa6fd820018 @attributes={:id=>2, :username=>"Harles Richey", :email=>"Harles@gmail.com"}>]
```
## Traverse association, retrieve record
```ruby
list = User.find(1).lists
# [#<List:0x007fa6fca13448 @attributes={:id=>1, :name=>"Shopping", :author_id=>1}>,
 #<List:0x007fa6fca132b8 @attributes={:id=>3, :name=>"Mike", :author_id=>1}>]

user = Task.find(1).user
#  #<User:0x007fa6fd158730 @attributes={:id=>1, :username=>"Aaron Grau", :email=>"Aroan@aol.com"}>
```

**NB:** When use '#has_one_through' association, it is depend on the association that it traverses.

```ruby
class Task < SQLObject
  belongs_to :list
  has_one_through :user,
    :list, #dependent association
    :user, #source
end
```

## Getting Started

Clone this repo into your project directory. \
Create models for all database tables and require 'SQLObject' in side each model.

### More Features later

* **validations** - Method that prevents invalid data entry.
* **callbacks** - Methods that allow certain events run at some points of the life-cycle of certain models.
