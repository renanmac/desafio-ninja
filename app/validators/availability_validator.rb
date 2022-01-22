class AvailabilityValidator < ActiveModel::Validator
  def validate(record)
    return unless booking_conflict?(record)

    record.errors.add(:booking_conflict, 'Já existe um evento na sala/horário selecionados')
  end

  private

  def booking_conflict?(record)
    query = booking_conflict_query

    Event
      .where(room_id: record.room_id)
      .where.not(id: record.id)
      .exists?([query, { start: record.start_at, end: record.end_at }])
  end

  def booking_conflict_query
    <<~SQL.squish
      (end_at BETWEEN :start AND :end) OR
      (start_at BETWEEN :start AND :end) OR
      (start_at <= :start AND end_at >= :end)
    SQL
  end
end
