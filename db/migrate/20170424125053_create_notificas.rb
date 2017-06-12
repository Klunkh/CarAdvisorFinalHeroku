class CreateNotificas < ActiveRecord::Migration[5.0]
  def change
    create_table :notificas do |t|
      t.references :user, foreign_key: true
      t.integer :notified_by, foreign_key: true
      t.string :tipo , default: false
      t.boolean :read

      t.timestamps
    end
  end
end
