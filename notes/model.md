# Rails Model Associations

  ## belongs_to
  Defines the "child" side of a relationship. This model has the foreign key.

  ```ruby
  class Mission < ApplicationRecord
    belongs_to :user  # missions table has user_id column
  end
  - mission.user returns the user
  - Required by default (mission must have a user)

  has_many

  Defines the "parent" side. The other table has the foreign key.

  class User < ApplicationRecord
    has_many :missions  # user can have many missions
  end
  - user.missions returns array of missions
  - user.missions.create(...) creates mission linked to user

  has_one

  Like has_many but only one record.

  class Task < ApplicationRecord
    has_one :skill  # completing a task earns one skill
  end
  - task.skill returns single skill (or nil)

  through

  Access a relationship through another model (join table).

  class User < ApplicationRecord
    has_many :user_domains
    has_many :domains, through: :user_domains
  end
  - user.domains returns domains via user_domains join table
  - Skips the middle model in queries

  dependent: :destroy

  When parent is deleted, delete children too.

  class Mission < ApplicationRecord
    has_many :tasks, dependent: :destroy
  end
  - Delete mission → all its tasks are deleted
  - Prevents orphaned records
  - Other options: :nullify (set foreign key to null), :restrict_with_error (prevent delete if children exist)
```


Automatic attribute accessors from columns:
  - Any column in your table becomes a method on the model
  - No need to declare attr_accessor or define getters/setters
  - Works for all types: strings, integers, booleans, jsonb, datetime, etc.

  JSONB columns:
  - Stored as JSON in PostgreSQL
  - Automatically converted to Ruby Hash when accessed
  - Great for flexible/schemaless data like metadata

 ```ruby
  The pattern:
  class Achievement < ApplicationRecord  # ← inherits the magic
    # achievement_type, metadata, achieved_at, etc.
    # are all available automatically from the schema

    def description
      # self.metadata, self.achievement_type available without declaring them
    end
  end
```
# This is why Rails is called "convention over configuration" 
# you don't configure these mappings, they just work based on naming conventions (table achievements → model Achievement, column  metadata → method metadata).