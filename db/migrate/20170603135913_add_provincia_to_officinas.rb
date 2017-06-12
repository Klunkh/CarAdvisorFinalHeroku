class AddProvinciaToOfficinas < ActiveRecord::Migration[5.0]
  def change
    add_column :officinas, :provincia, :string
  end
end
