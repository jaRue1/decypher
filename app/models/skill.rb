class Skill < ApplicationRecord
  belongs_to :user
  belongs_to :domain
  belongs_to :task
end
