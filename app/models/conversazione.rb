class Conversazione < ApplicationRecord
  belongs_to :user
  belongs_to :destinatario
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :destinatario_id, presence: { :message => ": inserire un'email"  }, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX , :message => ":formato non supportato"}
                    
					
  validates :messaggio, presence: { :message => ": inserire un messaggio" }, length: { maximum: 750 }
end
