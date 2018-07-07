#encoding: utf-8
class Admin::FilesController < ApplicationController
  require 'csv'
  before_action :authenticate_administrator!

  def index
  end

  def create
    if !params[:upload].present?
      flash[:error] = "No ha cargado archivo"
    else 
      file = params[:upload][:file]
      csv_text = file.read.force_encoding('ISO-8859-1')
      csv = CSV.parse(csv_text, :headers => true, :col_sep => ";")
      # Headers
      # Rut;Apellido socio;Nombre socio;Email;clave;celular;direccion;Pais;Nacimiento;Numero de socio;Numero Licencia;tipo de licencia;Permiso sistema;Tipo Socio;Estado Socio
      csv.each do |row|
        rut = row["Rut"].gsub(/\-/, '')
        if row["Estado Socio"] == 'En vuelo'
          membership_state = 1
        elsif row["Estado Socio"] == 'Fuera de vuelo'
          membership_state = 0
        else
          membership_state = -1
        end
        member_params = { 
          rut: rut,
          last_name: row["Apellido socio"],
          name: row["Nombre socio"],
          email: row["Email"],
          password: row["clave"],
          password_confirmation: row["clave"],
          phone: row["celular"] != nil ? row["celular"] : '00000000',
          address: row["direccion"],
          country: row["Pais"],
          birthdate: row["Nacimiento"],
          membership_number: row["Numero socio"],
          license_number: row["Numero Licencia"],
          license_type: row["tipo de licencia"],
          user_role: row["Permiso sistema"] == 'usuario' ? 0 : 1,
          membership_type: row["Tipo Socio"],
          membership_state: membership_state
        }

        begin
          newMember = User.find_or_initialize_by(rut: rut)

          if newMember.new_record?
            newMember.assign_attributes(member_params)
            newMember.save!
          else
            # Found an existing member, update it
            puts "EXISTE, actualizar a #{newMember.attributes}"
            newMember.update_attributes(member_params)
          end
        rescue ActiveRecord::RecordNotUnique
          retry
        end
      end
      flash[:success] = "Usuarios creados o actualizados correctamente"
    end

    redirect_to admin_files_path
  end

  def materials
    if !params[:upload].present?
      flash[:error] = "No ha cargado archivo"
    else
      file = params[:upload][:file]
      csv_text = file.read.force_encoding('ISO-8859-1')
      csv = CSV.parse(csv_text, :headers => true, :col_sep => ";")
      # Headers
      # Rut;Material
      csv.each do |row|
        rut = row["Rut"].gsub(/\-/, '')
        member = User.find_by(rut: rut)
        material = Aeroplane.find_by(plate: row["Material"])

        member.aeroplanes << material
      end

      flash[:success] = "Habilitaciones agregadas correctamente"
    end

    redirect_to admin_files_path
  end
end