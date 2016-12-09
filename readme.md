# DynamicData

DynamicData is a lightweight SQLite3 ORM(Object Relation Mapping).

DynamicData uses SQL queries and meta programming to connect models to the information in your database. Through APIs provided in DynamicData, you can bridge the models and perform CRUD operations easily.

## Getting Started

* Upgrade your ruby version to 2.3.1.
* Clone this repo into your project directory.
* Move your project into model folder.
* Bundle install.
* Require 'associatable' in your project.

```ruby
  require_relative '../lib/associatable'
```
* Have your class inherit from "SQLObject".
```ruby
  class Task < SQLObject
```
* Move your .sql file into the root directory.
* Change "Todo.sql" in line 5 and "Todo.db" in line 6 in the db_connection file to the path of your database.

```ruby
SQL_FILE = File.join(ROOT_FOLDER, 'Todo.sql') #change Todo.sql to yourdatabase.sql
DB_FILE = File.join(ROOT_FOLDER, 'Todo.db') #change Todo.db to yourdatabase.db
```
### CRUD operations
```ruby
  Task.new(params) #creates a new task without saving it into the database.
  Task.create(params) #creates a new task and saves it into the database.

  task = Task.find(id) #finds a specific task by given id in the tasks table. You can perform following operations.
  task.save(params) #saves the (newly created / edited) task into the database.
  task.destroy() #deletes the task from your database.
```
## Features
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
### Retrieve record
```ruby
users = User.all
#[#<User:0x007fa6fd820360 @attributes={:id=>1, :username=>"Aaron Grau", :email=>"Aroan@aol.com"}>,
#<User:0x007fa6fd820018 @attributes={:id=>2, :username=>"Harles Richey", :email=>"Harles@gmail.com"}>]
```
### Retrieve record through associations

**NB:** When using the '#has_one_through' association, make sure the declaring model has one instance that matches another model.

* Create an association through associations.
```ruby
class Task < SQLObject
  belongs_to :list
  has_one_through :user,
    :list, #dependent association
    :user, #source
end
```
* Retrieve record
```ruby
list = User.find(1).lists
# [#<List:0x007fa6fca13448 @attributes={:id=>1, :name=>"Shopping", :author_id=>1}>,
 #<List:0x007fa6fca132b8 @attributes={:id=>3, :name=>"Mike", :author_id=>1}>]

user = Task.find(1).user
#  #<User:0x007fa6fd158730 @attributes={:id=>1, :username=>"Aaron Grau", :email=>"Aroan@aol.com"}>
```
## Features to add

* **validations** - Method that prevents invalid data entry.
* **callbacks** - Methods that allow certain events to run at some point of the life-cycle of certain models.
