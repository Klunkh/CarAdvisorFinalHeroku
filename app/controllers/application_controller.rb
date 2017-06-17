class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :notifica
  before_action :controlloScadenze
  
 
 
 
private

def controlloScadenze
  require 'date'
  @scadenze=Scadenze.all
  @autoveicolo=Autoveicolo.all
  
  @scadenze.where(notificato: 'f').find_each do |scadenze|
	
	if(scadenze.tipo =="Assicurazione")
		oggi=get_data()
  		stipulazione=scadenze.dataStipulazione
  		giorni=(oggi.mjd - stipulazione.mjd).to_i
		rinnovo=(((scadenze.tipoScadenza).to_i)*30).to_i
		if(giorni>rinnovo)
			create_notifica(scadenze.targa, "Scadenza Assicurazione Prossima")
			scadenze.update(:notificato => 't')
		end
	
	elsif(scadenze.tipo=="Gomme") 
		@autoveicolo.where(id: scadenze.targa).find_each do |autoveicolo|
		
		if(autoveicolo.media.nil? || autoveicolo.media==0)
		autoveicolo.update(:media => 1)
	end
		km_medi_giorno=autoveicolo.media
		data_stipula=scadenze.dataStipulazione.mjd
		data_creazione=((scadenze.created_at).to_date).mjd #=> conversione del created_at in mjd
		giorni_necessari=(((scadenze.km).to_i/km_medi_giorno.to_i)+data_stipula.to_i) #=> calcolo dei Km_desiderati_per_cambio_gomme\media_km_giornalieri
		
		#creazione della prima scadenza.
		if(scadenze.data_scadenza.nil?)
			scadenze.update(:data_scadenza => giorni_necessari.to_f)
		
		#se mancano 5 giorni al giorno stimato del cambio gomme crea la notifica e setta il notificato
		elsif(scadenze.data_scadenza-3<get_data().mjd || (data_stipula+(365*3))-3<get_data().mjd)
			create_notifica(scadenze.targa, "Necessario cambio gomme a breve")
			scadenze.update(:notificato => 't')
		
		#se è passato almento un giorno dal giorno della creazione della notifica aggiorna i giorni_necessari nel caso siano cambiati i km_medi_al_giorno	
		elsif(data_creazione<get_data().mjd)
			print("UPDATE_SCADENZA_MEDIA \n")
			giorni_necessari=(((scadenze.km).to_i/km_medi_giorno.to_i)+data_stipula.to_i)
			scadenze.update(:data_scadenza => giorni_necessari.to_f)
			
		
		end
	end

    
    elsif(scadenze.tipo=="Tagliando")
        @autoveicolo.where(id: scadenze.targa).find_each do |autoveicolo|
        if(autoveicolo.media.nil? || autoveicolo.media==0)
		autoveicolo.update(:media => 1)
	end
	km_medi_giorno=autoveicolo.media
	data_stipula=scadenze.dataStipulazione.mjd
        data_creazione=((scadenze.created_at).to_date).mjd
        giorni_necessari=(((scadenze.km).to_i/km_medi_giorno.to_i)+data_stipula)
        
        if(scadenze.data_scadenza.nil?)
            scadenze.update(:data_scadenza => giorni_necessari.to_f)
            
        elsif(scadenze.data_scadenza-2<get_data().mjd || (data_stipula+362)<get_data().mjd)
            print("Creazione Notifica Tagliando...")
            create_notifica(scadenze.targa, "Tagliando necessario tra pochi giorni")
            scadenze.update(:notificato => 't')
        elsif(scadenze.data_scadenza<get_data().mjd)

            create_notifica(scadenze.targa, "Tagliando scaduto")
            scadenze.update(:notificato => 't')
        elsif(data_creazione<get_data().mjd)
            print("UPDATE_SCADENZA_MEDIA_TAGLIANDO \n")
			giorni_necessari=(((scadenze.km).to_i/km_medi_giorno.to_i)+data_stipula.to_i)
			scadenze.update(:data_scadenza => giorni_necessari.to_f)
        end
    end

    elsif(scadenze.tipo=="Revisione")
	@autoveicolo.where(id: scadenze.targa).find_each do |autoveicolo|
        if(autoveicolo.media.nil? || autoveicolo.media==0)
		autoveicolo.update(:media => 1)
	end
	data_stipulazione=((scadenze.dataStipulazione).to_date).mjd
	scadenza_revisione=365
	scadenza_prevista=data_stipulazione
	if(scadenze.tipoScadenza.to_i==24)
	scadenza_revisione=365*2
	scadenza_prevista=(data_stipulazione.to_i)+scadenza_revisione
	end
	if (scadenze.tipoScadenza.to_i==48)
	scadenza_revisione=365*4+1
	scadenza_prevista=(data_stipulazione.to_i)+scadenza_revisione
	end
	scadenze.update(:data_scadenza => scadenza_prevista)
	if(scadenza_prevista-4<=get_data().mjd)
            create_notifica(scadenze.targa, "Scadenza Revisione tra pochi giorni")
            scadenze.update(:notificato => 't')
	elsif(scadenza_prevista < get_data().mjd)
	    create_notifica(scadenze.targa, "Revisione scaduta")
            scadenze.update(:notificato => 't')
	end
	end

    elsif(scadenze.tipo=="Bollo")
	@autoveicolo.where(id: scadenze.targa).find_each do |autoveicolo|
        if(autoveicolo.media.nil? || autoveicolo.media==0)
		autoveicolo.update(:media => 1)
	end
	data_stipulazione=((scadenze.dataStipulazione).to_date).mjd
        scadenza_bollo=data_stipulazione.to_i+365
		scadenze.update(:data_scadenza => scadenza_bollo)
	if(scadenza_bollo-4<=get_data().mjd)
            create_notifica(scadenze.targa, "Scadenza Bollo tra pochi giorni")
            scadenze.update(:notificato => 't')
	end 
	end
 end
end
end 




def get_data()
	oggi=Time.now.strftime("%Y/%m/%d")
  	oggi=Date.parse(oggi)
	return oggi
end


def converti_mail_id (id_user)
    @user=User.all
    @user.where(id: id_user).find_each do |utente|
    return utente.email
    end
  end
  
def notifica 
  @notifica=Notifica.all
end


def create_notifica(id_macchina,msg)
     Notifica.create(user_id: current_id,
                        notified_by_id: id_macchina ,
                        tipo: msg,
						read: 'f',
                        )
end
include SessionsHelper


end
