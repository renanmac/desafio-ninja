class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :all_day
      t.string :owner_email
      t.references :schedule, null: false, foreign_key: true

      t.timestamps
    end
  end
end
