class Objective < ApplicationRecord
  belongs_to :mission
  has_many :skills
end
