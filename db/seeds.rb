schedule = Schedule.create(
  name: 'GetNinjas',
  description: 'Calendário criado para gerenciamento das reuniões do time do GetNinjas',
  open_time: '09:00',
  close_time: '18:00'
)

['Sub-zero', 'Scorpion', 'Kitana', 'Noob Saibot'].each do |ninja|
  Room.create(
    name: ninja,
    schedule_id: schedule.id
  )
end
