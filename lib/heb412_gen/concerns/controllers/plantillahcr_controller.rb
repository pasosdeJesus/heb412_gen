# encoding: UTF-8

module Heb412Gen
  module Concerns
    module Controllers
      module PlantillahcrController

        extend ActiveSupport::Concern

        included do
          include ActionView::Helpers::AssetUrlHelper
          include Sip::FormatoFechaHelper
          include Sip::ModeloHelper
  
          before_action :set_plantillahcr, only: [:edit, :update, :destroy, 
                                         :show, :impreso]
          load_and_authorize_resource  class: Heb412Gen::Plantillahcr

          @vista= nil
          attr_accessor :form_f

          # Vuelve a pintar asociación de campos con base en elección 
          # de controlador
          def pintacampos
            @plantillahcr = Heb412Gen::Plantillahcr.new
            if params[:vista]
              vista = Sip::Ubicacion.connection.quote_string(
                params[:vista] ).strip
              ab = ::Ability.new
              if ab.campos_plantillas[vista]
                @plantillahcr.vista = vista 
                @vista = vista
                respond_to do |format|
                  format.html {
                    render partial: 'form_divcampos_plantillahcr',
                      layout: false, locals: { vista: @vista }
                  }
                  format.js {
                    render partial: 'form_divcampos_plantillahcr',
                      layout: false, locals: { vista: @vista }
                  }
                end
              end
            end
          end

          def clase
            'Heb412Gen::Plantillahcr'
          end

          def atributos_show
            [:id, 
             :ruta, 
             :fuente, 
             :licencia, 
             :vista, 
             :nombremenu, 
            ]
          end

          def atributos_index
            [ :id, 
              :vista, 
              :nombremenu, 
              :ruta, 
              :licencia
            ]
          end

          def index_reordenar(c)
            c.reorder([:vista, :nombremenu])
          end

          # GET /plantillahcr/nueva
          def new
            authorize! :edit, Heb412Gen::Plantillahcr
            @plantillahcr = Heb412Gen::Plantillahcr.new
            @plantillahcr.vista = 'Usuario'
            @vista = nil
            render :new, layout: 'layouts/application'
          end

          # Completa @plantillahcr ya guardado. Debe terminar guardando.
          def ordena_plantillahcr
            @plantillahcr.save
          end

          def create_gen(plantillahcr)
            respond_to do |format|
              if plantillahcr.save
                ordena_plantillahcr
                format.html { 
                  redirect_to @plantillahcr,
                  notice: 'Plantilla para hoja de cálculo con un registro llenada.' }
                format.json {
                  render :show, 
                  status: :created, 
                  location: plantillahcr }
              else
                format.html { render :new }
                format.json { 
                  render json: plantillahcr.errors, 
                  status: :unprocessable_entity }
              end
            end
          end

          # POST /plantillahcr
          # POST /plantillahcr.json
          def create
            authorize! :edit, Heb412Gen::Plantillahcr
            @plantillahcr = Heb412Gen::Plantillahcr.new(plantillahcr_params)
            if !@plantillahcr.nombremenu && @plantillahcr.ruta
              @plantillahcr.nombremenu = File.basename(@plantillahcr.ruta)
            end
            create_gen(@plantillahcr)
          end

          # GET /plantillahcr/1/edit
          def edit
            authorize! :edit, Heb412Gen::Plantillahcr
            render :edit, layout: 'layouts/application'
          end

          # PATCH/PUT /plantillahcr/1
          # PATCH/PUT /plantillahcr/1.json
          def update
            authorize! :edit, Heb412Gen::Plantillahcr
            @vista = @plantillahcr.vista
            respond_to do |format|
              if @plantillahcr.update(plantillahcr_params)
                ordena_plantillahcr
                format.html { 
                  redirect_to @plantillahcr, 
                  notice: 'Plantilla para hoja de cálculo para ' +
                  'un registro actualizada.' 
                }
                format.json { render :show, status: :ok, 
                              location: @plantillahcr }
              else
                format.html { render :edit }
                format.json { 
                  render json: @plantillahcr.errors, 
                  status: :unprocessable_entity 
                }
              end
            end
          end

          # DELETE /plantillahcrs/1
          # DELETE /plantillahcrs/1.json
          def destroy
            authorize! :edit, Heb412Gen::Plantillahcr
            @plantillahcr.destroy
            respond_to do |format|
              format.html { 
                redirect_to Rails.configuration.relative_url_root,
                  notice: 'Plantillahcr eliminada.' 
              }
              format.json { head :no_content }
            end
          end

          # Llena una plantilla para un registro
          # a partir de una fuente de datos (hash o descendiente ActiveModel)
          def self.llena_plantilla_fd(plantillahcr, fd)
            ruta = File.join(Rails.application.config.x.heb412_ruta, 
                             plantillahcr.ruta).to_s
            puts "ruta=#{ruta}"
            libro = Rspreadsheet.open(ruta)
            hoja = libro.worksheets(1)
            plantillahcr.campoplantillahcr.each do |c|
              next if !c.columna || c.columna =='' || 
                !c.fila ||
                !c.nombrecampo || c.nombrecampo == ''
              col = (('A'..'CZ').to_a.find_index(c.columna))+1
              if fd.respond_to?(:presenta)
                v = fd.presenta(c.nombrecampo)
              elsif fd.respond_to?(c.nombrecampo.to_sym)
                v = fd.send(c.nombrecampo.to_sym)
                if v.respond_to?(:presenta_nombre)
                  v = v.presenta_nombre
                end
              else
                v = fd[c.nombrecampo] 
              end
              if !v.is_a? Integer
                v = v.to_s
              end

              puts "fila=#{c.fila}, col=#{col}, " +
                "c.nobmrecampo=#{c.nombrecampo}, r[c.nombrecampo]=#{v}"
              hoja[c.fila, col] = v
            end

            n=File.join('/tmp', File.basename(plantillahcr.ruta))
            libro.save(n)

            return n
            #send_file n, x_sendfile: true
              #type: 'application/vnd.oasis.opendocument.text',
              #disposition: 'attachment',
              #filename: 'elnombre.ods'

          end

          def impreso
            reg = {}
            @plantillahcr.campoplantillahcr.each do |c|
              reg[c.nombrecampo] =  "1 - " + c.nombrecampo
            end
            n = Heb412Gen::PlantillahcrController.llena_plantilla_fd(
              @plantillahcr, reg)
            send_file n, x_sendfile: true,
              type: 'application/vnd.oasis.openplantillahcrument.text'
              #disposition: 'attachment',
              #filename: 'elnombre.ods'
          end

          private
          # Use callbacks to share common setup or constraints between actions.
          def set_plantillahcr
            @plantillahcr = Plantillahcr.find(params[:id])
          end

          # Never trust parameters from the scary internet, only allow the white list through.
          def plantillahcr_params
            params.require(:plantillahcr).permit(
              :fuente,
              :licencia,
              :nombremenu, 
              :ruta,
              :vista,
              :campoplantillahcr_attributes => [
                :id,
                :nombrecampo,
                :columna,
                :fila,
                :_destroy
              ]
            )
          end
        end

      end
    end
  end
end
