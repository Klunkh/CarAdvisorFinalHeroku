class Operazioni < ApplicationRecord
  #belongs_to :autoveicolos
  
 
  
  def controlla_data
  
		if data!=nil && data > Date.today
			errors.add(:date, ": la data non può essere nel futuro")
		end
	end 
	
	
  validates :oggetto,presence: {:message => " : inserire l'oggetto"}
  validates :costo, presence: {:message => " : inserire il costo"},length: { maximum: 12 }
  validates :km, presence: {:message => " : inserire i kilometri percorsi"},length: { maximum: 12 }
  validates :data, presence: {:message => " : inserire una data"}
  validate :controlla_data
end
