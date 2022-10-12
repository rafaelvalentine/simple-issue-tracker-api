class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :title
      t.text :description
      t.references :sprint, null: false, foreign_key: true, type: :uuid
      t.boolean :is_completed, :null => false, default: false
      t.boolean :is_active, :null => false, default: true

      t.timestamps
    end
  end
end
