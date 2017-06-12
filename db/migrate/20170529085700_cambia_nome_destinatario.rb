class CambiaNomeDestinatario < ActiveRecord::Migration[5.0]
  def change
  rename_column :conversaziones, :destinatario, :destinatario_id
  end
end
