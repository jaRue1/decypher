class Mission < ApplicationRecord
  belongs_to :user
  belongs_to :domain
  has_many :objectives, dependent: :destroy
end
