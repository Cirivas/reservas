class Admin::AeroplanesController < ApplicationController
  
  before_action :set_aeroplane, only: [:edit, :update, :show, :destroy]

  # GET /admin/aeroplanes
  def index
    @aeroplanes = Aeroplane.all
  end


  # POST /admin/aeroplanes
  def create
    @aeroplane = Aeroplane.new(aeroplane_params)

    if @aeroplane.save
      flash[:success] = "Material creado correctamente"
      redirect_to admin_aeroplane_path(@aeroplane)
    else
      render action: "new"
    end
  end

  # GET /admin/aeroplanes/new
  def new
    @aeroplane = Aeroplane.new
  end

  # GET /admin/aeroplanes/:id/edit
  def edit
  end

  # GET /admin/aeroplanes/:id
  def show
  end

  # PATCH/PUT /admin/aeroplanes/:id
  def update
    if @aeroplane.update_attributes(aeroplane_params)
      flash[:success] = "Material actualizado correctamente"
      redirect_to admin_aeroplane_path(@aeroplane)
    else
      render action: "edit" 
    end
  end

  # DELETE /admin/aeroplanes/:id
  def destroy
    if @aeroplane.destroy
      flash[:success] = "Material eliminado con éxito"
    else
      flash[:error] = "No se pudo eliminar el material"
    end
    redirect_to admin_aeroplanes_path
  end

  private

    def set_aeroplane
      @aeroplane = Aeroplane.find(params[:id])
    end

    def aeroplane_params
      params.require(:aeroplane).permit(:plate, :brand, :plane_type, :next_revision, :flying_time, :state)
    end

end
