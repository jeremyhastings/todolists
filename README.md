## TodoLists

The overall goal of this project is to create a basic CRUD functionality of Active Record.  There will be four models: Users, TodoLists, TodoItems, and Profiles.  Users will have TodoLists which will contain TodoItems.  Profiles will allow Users to access all of their TodoLists.

### Getting Started

1. Create the project.

    ```shell
    $ rails new todolists
    ```

2. Add the following specification to your Gemfile to enable rspec testing.

    ```shell
    group :test do
      gem 'rspec-rails', '~> 4.0.0'
    end
    ```

3. Run the bundle command to resolve new gems.

    ```shell
    $ bundle install
    ```

4. Initialize the rspec tests using rails generate rspec:install command..

    ```shell
    $ rails generate rspec:install
    ```

5. Run RSpec.

    ```shell
    $ rspec --format documentation
    ```

### Technical Requirements

1. Create a User Model with a) username - a string to hold account identity and b) password_digest - a string to hold password information.

    ```shell
    $ rails g model user username password_digest
    $ rails db:migrate
    ```

2. Create a Profile Model with a) gender - a string to hold the words "male" or "female", b) birth_year - a number to hold the year the individual was born, c) first_name - a string with given name of user, d) last_name - a string with family name of user, e) user - a 1:1 relationship with User (i.e., Profile belongs_to User)

    ```shell
    $ rails g model profile gender birth_year:integer first_name last_name user:references
    $ rails db:migrate
    ```

3. Define the 1:1 has_one relationship in the User model class.

    ```shell
    class User < ActiveRecord::Base
	    has_one :profile, dependent: :destroy
      ...
    end
    ```

4. Create a TodoList Model with a) list_name - a string name assigned to the list, b) list_due_date - a date when todo items in the list are to be complete.

    ```shell
    $ rails g model TodoList list_name list_due_date:date
    $ rails db:migrate
    ```

5. Create a database migration (hint: rails g migration) that adds a database reference from the TodoLists table to the
Users table.

    ```shell
    $ rails g migration add_user_to_todo_lists user:references
    $ rails db:migrate
    ```

6. Define the many:1 belongs_to relationship in the TodoList model class.

    ```shell
    class TodoList < ApplicationRecord
      belongs_to :user
    end
    ```

7. Define the 1:many has_many relationship in the User model class.

    ```shell
    class User < ApplicationRecord
      has_many :todo_lists, dependent: :destroy
    end
    ```

8. Create a TodoItem model with: a) due_date - date when the specific task is to be complete, b) title - a string with short name for specific task, c) description - a text field with narrative text for specific task, d) completed - a boolean value (default=false), indicating whether item is complete, e) todo_list - a many:1 relationship with TodoList - TodoItem belongs_to TodoList

    ```shell
    $ rails g model TodoItem due_date:date title description:text completed:boolean todo_list:references
    ```

9. Define the many:1 belongs_to relationship in the TodoItem model class.

    ```shell
    class TodoItem > ApplicationRecord
      belongs_to :todo_list
    end
    ```

10. Define the 1:many has_many relationship in the TodoList model class.

    ```shell
    class TodoList > ApplicationRecord
      has_many :todo_items, dependent: :destory
    end
    ```

11. Define a 1:many through relationship with TodoItem through TodoLists (i.e., User has_many
todo_items)

    ```shell
    class User > ApplicationRecord
      has_many :todo_items, through: :todo_lists, source: :todo_items
    end
    ```

12. Add default_scope to both TodoList and TodoItem models to always return collectons from the database ordered by
due dates with earliest dates first.

  ```shell
  default_scope { order due_date: :asc }

  default_scope { order list_due_date: :asc }
  ```

13. Add validation to User model.  Define a validation for username to enforce that username be supplied by using a built-in validator

```shell
  validates :username, presence: true
```

14. Add validation to Profile model.  Define custom validator that permits first_name or last_name to be null but not both.  Define a validation for gender to be either "male" or "female" by using a built-in validator.  Define custom validator that prevents anyone that is male (gender) from having the first_name "Sue".

```shell
  validates :gender, inclusion: ["male", "female"]

  validate :both_names_not_null
  validate :no_boy_named_sue

  def both_names_not_null
  	if first_name == nil && last_name == nil
  		errors.add(:first_name, "cannot be nil if Last Name is nil!")
  	end
  end

  def no_boy_named_sue
  	if gender == "male" && first_name == "Sue"
  		errors.add(:first_name, "cannot be Sue if gender is male!")
  	end
  end
```

15.  Add a method to the User model class called get_completed_count, which determines the number of TodoItems the User has completed using an aggregate query function.

```shell
	def get_completed_count
		self.todo_items.where(completed: true).count
	end
```

16.  Add a class method to the Profile class, called get_all_profiles, which accepts a min and max for the birth year
issues a BETWEEN SQL clause in a where clause to locate Profiles with birth years that are between min year and max yeardefends itself against SQL injection when applying the parameters to the SQL clauses returns a collection of Profiles in ASC birth year order

```shell
  def self.get_all_profiles(min_birth_year, max_birth_year)
  	Profile.where("birth_year BETWEEN :min_birth_year AND :max_birth_year", min_birth_year: min_birth_year, max_birth_year:         
      max_birth_year)
      .order(birth_year: :asc)
      .to_a
  end
```

17.  Uncomment out the bcrypt gem in Gemfile.

```shell
gem 'bcrypt', '~> 3.1.7'
```

18.  Add the Will_Paginate gem to the Gemfile.

```shell
gem 'will_paginate', '~> 3.0.6'
```

19.  Add has_secure_password to the User model class.

```shell
class User < ApplicationRecord
  has_secure_password
  ...
end
```

20.  Use the rails g scaffold_controller command to create controller and view artifacts for TodoLists and TodoItems.

```shell
$ rails g scaffold_controller TodoList list_name list_due_date:date
$ rails g scaffold_controller TodoItem title due_date:date description:text completed:boolean
```

21.  Update config/routes.rb

```shell
  resources :todo_lists, except: [:index] do
    resources :todo_items, except: [:index]
  end

  root to: "todo_lists#index"

```

22.  Create a Sessions controller with the new, create, and destroy actions.

```shell
$ rails g controller sessions new create destory
```

23.  Change routes.rb to include:

```shell
resources :sessions, only: [:new, :create, :destroy]

get "/login" => "sessions#new", as: "login"
delete "/logout" => "sessions#destroy", as: "logout"
```
