class UsersController < ApplicationController
  def index
    users = UserFilterService.new(search_params).call
    render json: users
  end

  def new
    @user = User.new

    render "users/new"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "Por favor, verifique seu e-mail para confirmar a conta."
    else
      render :new
    end
  end

  def confirm
    user = User.find_by(confirmation_token: params[:token])

    if user && !user.confirmed?
      user.update(confirmed: true, confirmation_token: nil)
      redirect_to confirmation_success_path, notice: "Conta confirmada com sucesso!"
    else
      redirect_to root_path, alert: "Token inválido ou conta já confirmada."
    end
  end

  def confirmation_success
  end

  private

  def search_params
    params.permit(:company_id, :user_username, :username, :display_name, :email)
  end

   def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :display_name, :company_id)
  end
end
