# encoding: UTF-8

module Heb412Gen
  module Concerns
    module Controllers
      module PlantillahcmController

        extend ActiveSupport::Concern

        included do
          include ActionView::Helpers::AssetUrlHelper
          include Sip::FormatoFechaHelper
  
          before_action :set_plantillahcm, only: [:edit, :update, :destroy, 
                                         :show, :impreso]

          # GET /plantillahcm/nueva
          def new
            authorize! :edit, Heb412Gen::Doc
            @plantillahcm = Heb412Gen::Plantillahcm.new
          end

          # Completa @plantillahcm ya guardado. Debe terminar guardando.
          def ordena_plantillahcm
            @plantillahcm.save
          end

          def create_gen(plantillahcm)
            respond_to do |format|
              if plantillahcm.save
                ordena_plantillahcm
                format.html { 
                  redirect_to @plantillahcm,
                  notice: 'Plantilla para hoja de cálculo con múltiples registros creada.' }
                format.json {
                  render :show, 
                  status: :created, 
                  location: plantillahcm }
              else
                format.html { render :new }
                format.json { 
                  render json: plantillahcm.errors, 
                  status: :unprocessable_entity }
              end
            end
          end

          # POST /plantillahcm
          # POST /plantillahcm.json
          def create
            authorize! :edit, Heb412Gen::Doc
            @plantillahcm = Heb412Gen::Plantillahcm.new(plantillahcm_params)
            if !@plantillahcm.nombremenu && @plantillahcm.ruta
              @plantillahcm.nombremenu = File.basename(@plantillahcm.ruta)
            end
            create_gen(@plantillahcm)
          end

          # GET /plantillahcm/1/edit
          def edit
            authorize! :edit, Heb412Gen::Doc
          end

          # PATCH/PUT /plantillahcm/1
          # PATCH/PUT /plantillahcm/1.json
          def update
            authorize! :edit, Heb412Gen::Doc
            respond_to do |format|
              if @plantillahcm.update(plantillahcm_params)
                ordena_plantillahcm
                format.html { 
                  redirect_to @plantillahcm, 
                  notice: 'Plantilla para hoja de cálculo con múltiples registros actualizada.' 
                }
                format.json { render :show, status: :ok, 
                              location: @plantillahcm }
              else
                format.html { render :edit }
                format.json { 
                  render json: @plantillahcm.errors, status: :unprocessable_entity 
                }
              end
            end
          end

          # DELETE /plantillahcms/1
          # DELETE /plantillahcms/1.json
          def destroy
            authorize! :edit, Heb412Gen::Doc
            @plantillahcm.destroy
            respond_to do |format|
              format.html { 
                redirect_to plantillahcms_url, 
                  notice: 'Plantillahcm eliminado.' 
              }
              format.json { head :no_content }
            end
          end

          # Llena una plantilla para multiples registros
          # a partir de una fuente de datos (tabla o vista)
          def self.llena_plantilla_multiple_fd(plantillahcm, fd)
            ruta = File.join(Rails.application.config.x.heb412_ruta, 
                             plantillahcm.ruta).to_s
            puts "ruta=#{ruta}"
            libro = Rspreadsheet.open(ruta)
            hoja = libro.worksheets(1)
            fila = plantillahcm.filainicial
            fd.each do |r|
              plantillahcm.campoplantillahcm.each do |c|
                #byebug
                col = (('A'..'CZ').to_a.find_index(c.columna))+1
                puts "fila=#{fila}, col=#{col}, c.nobmrecampo=#{c.nombrecampo}, r[c.nombrecampo]=#{r[c.nombrecampo]}"
                hoja[fila, col] = r[c.nombrecampo]
              end
              fila += 1
            end 

            n=File.join('/tmp', File.basename(plantillahcm.ruta))
            libro.save(n)

            return n
            #send_file n, x_sendfile: true
              #type: 'application/vnd.oasis.openplantillahcmument.text',
              #disposition: 'attachment',
              #filename: 'elnombre.ods'

          end

          def impreso
            fd = []
            (1..3).each do |nr|
              reg = {}
              @plantillahcm.campoplantillahcm.each do |c|
                reg[c.nombrecampo] = nr.to_s + " - " + c.nombrecampo
              end
              fd << reg
            end 

            n = Heb412Gen::PlantillahcmController.llena_plantilla_multiple_fd(
              @plantillahcm, fd)
            send_file n, x_sendfile: true
              #type: 'application/vnd.oasis.openplantillahcmument.text',
              #disposition: 'attachment',
              #filename: 'elnombre.ods'
          end

          private
          # Use callbacks to share common setup or constraints between actions.
          def set_plantillahcm
            @plantillahcm = Plantillahcm.find(params[:id])
          end

          # Never trust parameters from the scary internet, only allow the white list through.
          def plantillahcm_params
            params.require(:plantillahcm).permit(
              :ruta,
              :descripcion,
              :fuente,
              :licencia,
              :vista,
              :nombremenu, 
              :filainicial,
              :campoplantillahcm_attributes => [
                :id,
                :nombrecampo,
                :columna
              ]
            )
          end
        end

      end
    end
  end
end
