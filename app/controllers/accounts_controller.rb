class AccountsController < ApplicationController
  before_action :authenticate_any!
  def index
    @accounts = Account.all
    @account = Account.new
  end

  def create
    account = Account.new(account_params)

    if account.save
      flash[:success] = "Cuenta subida con éxito"
    else
      flash[:error] = "No se guardó el archivo, #{account.errors.inspect}"
    end
    redirect_to accounts_path
  end

  private

  def account_params
    params.require(:account).permit(:file)
  end
end
