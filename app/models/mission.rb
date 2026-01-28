class Mission < ApplicationRecord
  belongs_to :user
  belongs_to :domain
  has_many :tasks, dependent :destroy
end
