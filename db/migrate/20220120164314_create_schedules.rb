class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.string :name
      t.text :description
      t.string :open_time
      t.string :close_time

      t.timestamps
    end
  end
end
