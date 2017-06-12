class PaginaStaticaController < ApplicationController
  def home
    require 'date'
	
	@conversazioni=Conversazione.all
	@conversaziones=@conversazioni.select(:user_id, :destinatario_id, :letto).distinct
    @autoveicolo=Autoveicolo.all
    @scadenze=Scadenze.all
    @data_passata=get_data_passata()
	@data_oggi = get_data_oggi()
  end
  def contattaci
  end
  def get_data_oggi
  require 'date' 
  oggi=Time.now.strftime("%Y/%m/%d")
  	oggi=Date.parse(oggi).mjd
	return oggi
  end
  def show 
  end
 private 
  def get_data_passata()
	oggi=Time.now.strftime("%Y/%m/%d")
  	oggi=Date.parse(oggi)
    data_passata=(oggi.mjd+30).to_i
    return data_passata
end

def converti_mail_id (id_user)
    @user=User.all
    @user.where(id: id_user).find_each do |utente|
    print (utente.email)
    return utente.email
    end
  end
  def get_nome_da_id (id_user)
    @user=User.all
    @user.where(id: id_user).find_each do |utente|
    print (utente.nome)
    return utente.nome + utente.cognome
    end
  end
end
