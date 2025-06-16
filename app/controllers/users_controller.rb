class UsersController < ApplicationController
  before_action :set_company, only: [:for_company, :new]
  def index
    users = UserFilterService.new(search_params).call
    render json: users
  end

  def for_company
    scoped_users = UserFilterService.new(company_id: @company.id).call
    paginated = paginate(scoped_users)

    @users = paginated[:records]
    @total_users = paginated[:total]
    @per_page = paginated[:per_page]
    @page = paginated[:page]

    render "users/for_company"
  end

  def new
    @user = User.new(company_id: @company.id)
    render "users/new"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to company_users_list_path(@user.company_id), notice: "Por favor, verifique seu e-mail para confirmar a conta."
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

  def paginate(scope)
    per_page = (params[:per_page] || 5).to_i.clamp(1, 100)
    page = (params[:page] || 1).to_i.clamp(1, Float::INFINITY)
    offset = (page - 1) * per_page

    {
      records: scope.offset(offset).limit(per_page),
      total: scope.count,
      per_page: per_page,
      page: page
    }
  end

  def set_company
    @company = Company.find(params[:company_id])
  end

  def search_params
    params.permit(:company_id, :user_username, :username, :display_name, :email)
  end

   def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :display_name, :company_id)
  end
end
