class Scadenze < ApplicationRecord
  belongs_to :user
  def get_targa
    "#{targa}"
  end
  
  def controlla_data
  
		if dataStipulazione!=nil && dataStipulazione > Date.today
			errors.add(:date, ": la data non può essere nel futuro")
		end
	end 
	
	
	 validates :dataStipulazione, presence: {:message => " : inserire una data"}
     validate :controlla_data
end
