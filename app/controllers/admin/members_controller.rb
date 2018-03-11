class Admin::MembersController < ApplicationController
  
  before_action :authenticate_administrator!
  before_action :set_member, only: [:edit, :update, :show, :destroy]

  # GET /admin/members
  def index
    @members = User.all
  end


  # POST /admin/members
  def create
    params[:user][:password_confirmation] = params[:user][:password]
    @member = User.new(member_params)

    if @member.save
      flash[:success] = "Socio creado correctamente"
      redirect_to admin_member_path(@member)
    else
      render action: 'new'
    end
  end

  # GET /admin/members/new
  def new
    @member = User.new
  end

  # GET /admin/members/:id/edit
  def edit
  end

  # GET /admin/members/:id
  def show
    @aeroplanes = @member.aeroplanes
  end

  # PATCH/PUT /admin/members/:id
  def update
    # Avoid the need of having always to set a password
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
    end
    
    if @member.update_attributes(member_params)
      flash[:sucess] = "Socio actualizado correctamente"
      redirect_to admin_member_path(@member)
    else
      render action: 'edit' 
    end
  end

  # DELETE /admin/members/:id
  def destroy
    if @member.destroy
      flash[:success] = "Socio eliminado correctamente"
    else
      flash[:error] = "No se pudo eliminar el socio"
    end
    redirect_to admin_members_path
  end

  private

    def set_member
      @member = User.find(params[:id])
    end

    def member_params
      params.require(:user).permit(:rut, :membership_number, :name, :last_name, :email, :password, :password_confirmation, :address, :phone, :country, :birthdate, :license_type, :license_number, :user_role, :membership_type, :membership_state, :aeroplane_ids => [])
    end

end
