class CreateOperazionis < ActiveRecord::Migration[5.0]
  def change
    create_table :operazionis do |t|
      t.references :user, foreign_key: true
      t.float :km
      t.date :data
      t.string :oggetto
      t.string :meccanico

      t.timestamps
    end
  end
end
