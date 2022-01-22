class Event < ApplicationRecord
  belongs_to :schedule

  validates :start_at,
            :end_at,
            :owner_email,
            presence: true

  validate :end_at_after_start_at,
           :business_hours,
           :in_the_past,
           :same_day,
           :weekend

  validates_with AvailabilityValidator

  def business_hours
    return if within_schedule?

    errors.add(:business_hours, 'O horário do evento está fora do horário comercial')
  end

  def end_at_after_start_at
    return if end_at > start_at

    errors.add(:end_at, 'A data de término do evento deve ser maior que a data de início')
  end

  def weekend
    return unless start_at.on_weekend? || end_at.on_weekend?

    errors.add(:weekend, 'Eventos não podem ser criados aos finais de semana')
  end

  def same_day
    return if start_at.to_date == end_at.to_date

    errors.add(:same_day, 'As datas de início e fim do evento estão em dias diferentes')
  end

  def in_the_past
    now = Time.current
    return if [start_at, end_at].all? { |date| date > now }

    errors.add(:in_the_past, 'Eventos não podem ser criados no passado')
  end

  private

  def within_schedule?
    schedule.within_time_limits?(start_at) && schedule.within_time_limits?(end_at)
  end
end
