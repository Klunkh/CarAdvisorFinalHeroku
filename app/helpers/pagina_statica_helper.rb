module PaginaStaticaHelper
def get_nome_da_id (id_user)
    @user=User.all
    @user.where(id: id_user).find_each do |utente|
    nome=utente.nome.to_s + ' ' + utente.cognome.to_s
    return nome
    end
  end
end
