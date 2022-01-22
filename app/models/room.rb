class Room < ApplicationRecord
  belongs_to :schedule
  has_many :events, dependent: :destroy
end
