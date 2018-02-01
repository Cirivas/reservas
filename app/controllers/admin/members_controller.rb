class Admin::MembersController < ActionController::Base
  
  before_action :set_member, only: [:edit, :update, :show, :destroy]

  # GET /admin/members
  def index
    @members = User.all
  end


  # POST /admin/members
  def create
    @member = User.new(member_params)

    if @member.save
      redirect_to admin_member_path(@member)
    else
      flash[:error] = @member.errors.messages
      redirect_to new_admin_member_path
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
  end

  # PATCH/PUT /admin/members/:id
  def update
    # Avoid the need of having always to set a password
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
    end
    
    if @member.update_attributes(member_params)
      redirect_to admin_member_path(@member)
    else 
      flash[:error] = @member.errors.messages
      redirect_to edit_admin_member_path(@member)
    end
  end

  # DELETE /admin/members/:id
  def destroy
  end

  private

    def set_member
      @member = User.find(params[:id])
    end

    def member_params
      params.require(:user).permit(:rut, :membership_number, :name, :last_name, :email, :password, :password_confirmation, :address, :phone, :country, :birthdate, :license_type, :license_number, :user_role, :membership_type, :membership_state)
    end

end
