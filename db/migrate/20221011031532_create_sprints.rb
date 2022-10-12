class CreateSprints < ActiveRecord::Migration[6.1]
  def change
    create_table :sprints, id: :uuid do |t|
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :is_active, :null => false, :default => true

      t.timestamps
    end
  end
end
