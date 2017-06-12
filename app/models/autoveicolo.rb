class Autoveicolo < ApplicationRecord
  #belongs_to :user
  #has_many :operazionis, dependent: :destroy
  #has_many :notificas, dependent: :destroy
  #has_many :scadenzes, dependent: :destroy

  VALID_TARGA_REGEX=/\A[a-zA-Z]{2}[0-9]{3,5}[a-zA-Z]{0,3}\z/i
  VALID_MODELLO_REGEX=/\A([A-Z]?[a-z]+)+(\s?[A-Z]?[a-z]*)*(\s?[A-Z]?[']?[a-z]+)*(\s?[0-9])*\z/i
  
  validates :targa, presence: { :message => " : inserire una targa" }, length: { maximum: 10 } ,
  format: { with: VALID_TARGA_REGEX , :message => " : formato non supportato"}
 
	
  validates :modello, presence: { :message => " : inserire un modello"  }, length: { maximum: 50 } ,
  format: { with: VALID_MODELLO_REGEX , :message => ":formato non supportato"}

  validates :kilometri, presence: {:message => " : inserire i kilometri percorsi"},length: { maximum: 9 }
  
   def get_targa
        "#{targa}"
   end

        
  end
