class CambiaTipoCellOfficina < ActiveRecord::Migration[5.0]
  def change
  change_column :officinas, :numero_telefono, :string
  end
  
end
