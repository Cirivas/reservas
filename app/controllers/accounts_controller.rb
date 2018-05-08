class AccountsController < ApplicationController
  before_action :authenticate_any!
  def index
    @accounts = Account.all
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      flash[:success] = "Cuenta subida con éxito"
      redirect_to accounts_path
    else
      flash[:error] = "No se guardó el archivo"
      @accounts = Account.all
      render :index
    end
  end

  def destroy
    account = Account.find(params[:id])

    if account.destroy
      flash[:success] = "Cuenta eliminada con éxito"
    else
      flash[:error] = "Cuenta no pudo ser eliminada"
    end

    redirect_to accounts_path
  end

  private

  def account_params
    params.require(:account).permit(:file)
  end
end
