class ConversazionesController < ApplicationController
before_action :logged_in_user, only: [:create]
skip_before_action :verify_authenticity_token

def reload
redirect_to("https://car-advisors.herokuapp.com/conversaziones/index")
end
 def ciccio()
	print(123456)
	end
def controlla_messaggi(mittente, ricevente)
   @conversazione=Conversazione.all
   @conversazione.where(user_id: mittente, destinatario_id: converti_mail_id(ricevente)).find_each do |messaggio|
   if(messaggio.letto=='t')
		print("TRUEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE \n")
		return true
   end
	end
	return false
	end
  def load_conversazione
	
    @conversazione=Conversazione.order(:created_at)
	@msg=@conversazione.where(user_id: params[:id1], destinatario_id: converti_mail_id(params[:id2])).or(@conversazione.where(destinatario_id: converti_mail_id(params[:id1]), user_id: params[:id2]))
    @ciao=@conversazione.where(destinatario_id: converti_mail_id(current_id))
	@ciao.find_each do |msg|
		msg.update(:letto => 't')
		end
    respond_to do |format|
    format.html { render :layout => false }
    end
   end
  def index
     @ciccio=ciccio()
     @messaggi=Scadenze.all
     @conversazione=Conversazione.all
     @conversaziones=@conversazione.select(:user_id, :destinatario_id).distinct
     @user=User.all
	 @ciotola=@conversazione.where(destinatario_id: converti_mail_id(current_id))
    
  end
  def new
     @conversazione=Conversazione.new
  end
  
  def create
     @conversazione=Conversazione.new(conversazione_params)
	 
	 if !User.exists?( :email => @conversazione.destinatario_id )||(current_user.email==@conversazione.destinatario_id)
	 respond_to do |format|
	 flash[:danger]= "Email non disponibile."
        format.html { render :new }
        format.json { render json: @conversazione.errors, status: :unprocessable_entity }
		end
	 else
    respond_to do |format|
     if @conversazione.save
	flash[:success] = "Messaggio inviato correttamente"
        format.html { redirect_to '/conversaziones/index'}
        format.json { render :show, status: :created, location: @conversazione }
      else
        flash.now[:danger]= "Errore invio messaggio, ricontrolla i dati inseriti"
        format.html { render :new }
        format.json { render json: @conversazione.errors, status: :unprocessable_entity }
      end
    end
	end
  end
  
  def cancella_notifica_messaggi
  @conversaziones=Conversazione.all
  pametro=converti_mail_id(params[:id])
  @conversazione=@conversaziones.where(destinatario_id: pametro)
  @conversazione.find_each do |conversazione|
  @conversazione.update(:letto => 't')
  
  end
  end
  private
  def conversazione_params
    params.require(:conversaziones).permit(:user_id, :destinatario_id, :messaggio, :letto, :inviato)
  end
  
  def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
  def trova_user_id (email_input)
    @user=User.all
    @user.where(email: email_input).find_each do |utente|
    return utente.id
    end
  end
  def converti_mail_id (id_user)
    @user=User.all
    @user.where(id: id_user).find_each do |utente|
    return utente.email
    end
  end
end
