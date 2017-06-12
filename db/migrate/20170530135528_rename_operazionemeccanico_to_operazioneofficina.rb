class RenameOperazionemeccanicoToOperazioneofficina < ActiveRecord::Migration[5.0]
  def change
  rename_column :operazionis, :meccanico, :officina
  end
end
