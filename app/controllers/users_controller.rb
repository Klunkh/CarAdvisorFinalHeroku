class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:show, :edit, :update]
  before_action :admin_user,     only: [:index, :destroy]



  skip_before_action :verify_authenticity_token  

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1[:show, :edit, :update, 
  # GET /users/1.json
  def show
 
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
      @user = User.find(params[:id])
	rescue ActiveRecord::RecordNotFound  
        redirect_to root_url
        flash[:info]="L'utente selezionato non esiste."
        return
  end

  # POST /users
  # POST /users.json
  def create
  @user = User.new(user_params)
  
	if User.exists?( :email => @user.email )
	respond_to do |format|
	flash[:danger]= "Errore,email non disponibile"
        format.html { redirect_to '/users/new' and return }
        format.json { render json: @user.errors, status: :unprocessable_entity }
		
	end

    
	else
	
    respond_to do |format|
      
      if @user.save
	@user.send_activation_email
        flash[:info] = "Controlla la tua email per attivare l'account."
        #redirect_to root_url
        format.html { redirect_to root_url}
        format.json { render :show, status: :created, location: @user }
      else
	flash.now[:danger]= "Errore creazione account"
        format.html {  redirect_to root_url }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    
    end
	end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
	@userProva=User.find(params[:id])
	if(@userProva.email==@user.email || !User.exists?( :email => @user.email ))
    respond_to do |format|
      
	
      if @user.update(user_params)
	flash[:success] = "Dati aggiornati correttamente."
        format.html { redirect_to @user}
        format.json { render :show, status: :ok, location: @user }
      else
	flash.now[:danger] = "Errore nella modifica dei dati personali."
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      
      end
    end
	else
	respond_to do |format|
	flash.now[:danger] = "Email non disponibile."
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
		end
	end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Utente cancellato correttamente."
    redirect_to root_url

    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:nome, :cognome, :email, :password, :tipo)
    end
    
      
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

   def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
	rescue ActiveRecord::RecordNotFound  
        redirect_to root_url
        flash[:info]="L'utente selezionato non esiste."
        return
    end
  def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
 
    
        
end
