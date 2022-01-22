require 'rails_helper'

RSpec.describe Event, type: :model do
  fixtures :schedules
  fixtures :rooms

  before(:all) do
    time = Time.zone.parse('2021-01-03 12:00:00')
    Timecop.travel(time)
  end

  def build_event(start_at, end_at)
    described_class.new(
      start_at: start_at,
      end_at: end_at,
      schedule_id: schedules(:getninjas).id,
      room_id: rooms(:subzero).id
    )
  end

  it 'Should not create events in the past' do
    start_at = 1.day.ago
    end_at = start_at + 1.hour
    event = build_event(start_at, end_at)

    expect(event.save).to be false
    expect(event.errors.messages[:in_the_past].first).to eq('Eventos não podem ser criados no passado')
  end

  it 'Should not create events in the weekends' do
    first_saturday_in_the_year = Date.commercial(2022, 1, 6)
    event = build_event(first_saturday_in_the_year, first_saturday_in_the_year + 1.hour)

    expect(event.save).to be false
    expect(event.errors.messages[:weekend].first).to eq('Eventos não podem ser criados aos finais de semana')
  end

  it 'Should not create events between days' do
    now = Time.current
    start_at = now + 1.day
    end_at = now + 2.days

    event = build_event(start_at, end_at)

    expect(event.save).to be false
    expect(event.errors.messages[:same_day].first).to eq('As datas de início e fim do evento estão em dias diferentes')
  end

  it 'Should not create events outside of business hours' do
    start_at = Time.zone.parse('05-05-2022 17:30:00')
    end_at = start_at + 2.hours

    event = build_event(start_at, end_at)

    expect(event.save).to be false
    expect(event.errors.messages[:business_hours].first).to eq('O horário do evento está fora do horário comercial')
  end

  it 'Should not create nested events' do
    start_at = 4.days.from_now
    end_at = start_at + 2.hours

    event1 = build_event(start_at, end_at)
    event1.save!

    event = build_event(start_at + 10.minutes, start_at + 1.hour)

    expect(event.save).to be false
    expect(event.errors.messages[:booking_conflict].first).to eq('Já existe um evento na sala/horário selecionados')
  end

  it 'Should not create overlapping events' do
    start_at = 4.days.from_now
    end_at = start_at + 2.hours

    event1 = build_event(start_at, end_at)
    event1.save!

    event = build_event(start_at + 1.hour, start_at + 3.hours)

    expect(event.save).to be false
    expect(event.errors.messages[:booking_conflict].first).to eq('Já existe um evento na sala/horário selecionados')
  end

  it 'Should create an event' do
    start_at = Time.zone.parse('05-05-2022 17:00:00')
    end_at = start_at + 1.hour

    event = build_event(start_at, end_at)

    expect(event.save).to be true
    expect(event.errors.messages).to be_empty
  end
end
