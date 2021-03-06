class AutoveicolosController < ApplicationController

before_action :utente_autoveicolo, only: [:destroy,:show, :update]
before_action :logged_in_user, only: [:create, :new]


skip_before_action :verify_authenticity_token  


  def destroy
   Autoveicolo.find(params[:id]).destroy
    flash.now[:success] = "Autoveicolo cancellato correttamente."
    redirect_to autoveicolos_url

    
  end

  def show
    @autoveicolo=Autoveicolo.find(params[:id])
    @operazione=Operazioni.all
	@operazioni=@operazione.where(user_id: current_id).find_each
    rescue ActiveRecord::RecordNotFound  
        redirect_to root_url
        flash[:info]="L'autoveicolo selezionato non esiste."
        return
  end

  def index
    @autoveicolo = Autoveicolo.all
    @preferito = Preferiti.all
  end

  def new
    @autoveicolo = Autoveicolo.new
  end
  
  def edit
    @autoveicolo=Autoveicolo.find(params[:id])
      redirect_to(root_path) unless @autoveicolo.user_id==current_id
	  
      rescue ActiveRecord::RecordNotFound  
        redirect_to root_url
        flash[:info]="L'autoveicolo selezionato non è accessibile."
        return
  end

  def update
  @autoveicolo = Autoveicolo.find(params[:id])
    respond_to do |format|
        if @autoveicolo.update(auto_params)
	    @autoveicolo.update(:media => update_media(@autoveicolo.id, @autoveicolo.kilometri, @autoveicolo.updated_at))
            flash[:success] = "Dati aggiornati correttamente."
            format.html { redirect_to @autoveicolo}
            format.json { render :show, status: :ok, location: @autoveicolo }
        else
            flash.now[:danger] = "Errore nella modifica dei dati."
            format.html { render :edit }
            format.json { render json: @autoveicolo.errors, status: :unprocessable_entity }
        end
    end
end
 
def create 
    @autoveicolo = Autoveicolo.new(auto_params)
    respond_to do |format|
     if @autoveicolo.save
	 @autoveicolo.update(:media => 0.0)
	flash[:success] = "Autoveicolo aggiunto correttamente"
        format.html { redirect_to autoveicolos_url + '/' + (@autoveicolo.id).to_s}
        format.json { render :show, status: :created, location: @autoveicolo }
      else
        flash.now[:danger]= "Errore aggiunta autoveicolo. Ricontrolla i dati per favore"
        format.html { render :new }
        format.json { render json: @autoveicolo.errors, status: :unprocessable_entity }
      end
    
    end
  end
  
private

     def update_media(id_auto,km_attuali,data)
	require 'date'
	@Inf =1.0/0.0
	@auto=Autoveicolo.all
	@automobile=Autoveicolo.find_by_id(id_auto)
	media_precedente=@automobile.media
	oggi=data.to_date.mjd #=> data in input convertita prima in data e poi in giorni
	@operazione=Operazioni.all
	ultima_operazione_data=@operazione.where(targa: id_auto).maximum(:data) #=>prendo la data dell'ultima operazione
	ultima_operazione_km=@operazione.where(targa: id_auto, data: ultima_operazione_data).find_each
	if ultima_operazione_data!=nil
	if(km_attuali>ultima_operazione_km.to_s.to_f && @operazione.where(targa: id_auto).count >0) #=>Se i km inseriti durante l'update sono maggiori di quelli precedenti aggiorna la media in "autoveicolos"
		media_giorni=oggi-ultima_operazione_data.mjd #=> calcolo data_update-data_ultima_operazione
		media_km=km_attuali-ultima_operazione_km.to_s.to_f #=> come sopra ma per i kim
		print("	UPDATE_MEDIA_AUTOVEICOLOS \n")
		if media_km/media_giorni!=@Inf
	    return(media_km/media_giorni)
		else return media_precedente
		end
	end
	else 
		return media_precedente
	end
	
	
	
end	
	
   def find_user
      ret = User.find(params[:id])
      return ret
   end   
   def find_nome_meccanico(input)
        @meccanico=User.where(id: input)
        ret=@meccanico.nome
        return ret
  end
  def find_nome_officina(input)
        @officina=Officina.where(id: input)
        ret=@officina.indirizzo
        return ret
  end
  def auto_params
      params.require(:autoveicolos).permit(:targa, :modello, :carburante, :kilometri, :user_id)
  end
  def logged_in_user
      unless logged_in?
        flash[:danger] = "Per favore effettua il log-in"
        redirect_to login_url
      end
    end

  def utente_autoveicolo
      @autoveicolo=Autoveicolo.find(params[:id])
      redirect_to(root_path) unless @autoveicolo.user_id==current_id
      rescue ActiveRecord::RecordNotFound  
        redirect_to root_url
        flash[:info]="L'autoveicolo non è accessibile."
        return
  end
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end

