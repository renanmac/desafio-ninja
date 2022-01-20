class Schedule < ApplicationRecord
  has_many :events
  has_many :rooms
end
