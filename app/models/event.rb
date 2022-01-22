class Event < ApplicationRecord
  belongs_to :schedule

  validate :business_hours,
           :in_the_past,
           :same_day,
           :weekend,
           :availability

  def business_hours
    return if within_schedule?

    errors.add(:business_hours, 'O horário do evento está fora do horário comercial')
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

  def availability
    return unless booking_conflict

    errors.add(:booking_conflict, 'Já existe um evento na sala/horário selecionados')
  end

  def booking_conflict
    query = booking_conflict_query

    self
      .class
      .where(room_id: room_id)
      .where.not(id: id)
      .exists?([query, { start: start_at, end: end_at }])
  end

  private

  def booking_conflict_query
    <<~SQL.squish
      (end_at BETWEEN :start AND :end) OR
      (start_at BETWEEN :start AND :end) OR
      (start_at <= :start AND end_at >= :end)
    SQL
  end

  def within_schedule?
    schedule.within_time_limits?(start_at) && schedule.within_time_limits?(end_at)
  end
end
