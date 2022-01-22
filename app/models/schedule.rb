class Schedule < ApplicationRecord
  has_many :events, dependent: :destroy
  has_many :rooms

  def within_time_limits?(datetime)
    time = datetime.strftime('%H:%M')

    time >= open_time && time <= close_time
  end
end
