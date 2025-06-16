class UserFilterService
  def initialize(params)
    @params = params
  end

  def call
    User.all
      .by_company(@params[:company_id])
      .by_username(@params[:username] || @params[:user_username])
      .by_display_name(@params[:display_name])
      .by_email(@params[:email])
      .confirmed
  end
end