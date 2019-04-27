# encoding: UTF-8

module Heb412Gen
  module Concerns
    module Controllers
      module DocsController

        extend ActiveSupport::Concern

        included do
          include ActionView::Helpers::AssetUrlHelper
          include Sip::FormatoFechaHelper
  
          before_action :set_doc, only: [:edit, :update, :destroy, 
                                         :show, :impreso]

          # GET /docs/new
          def new
            authorize! :edit, Heb412Gen::Doc
            @doc = Heb412Gen::Doc.new
          end

          # Completa @doc ya guardado. Debe terminar guardando.
          def ordena_doc
            @doc.save
          end

          def create_gen(doc)
            respond_to do |format|
              if doc.save
                ordena_doc
                format.html { 
                  redirect_to docs_url, notice: 'Documento creado.' 
                }
                format.json { render :show, status: :created, location: doc }
              else
                format.html { render :new }
                format.json { render json: doc.errors, status: :unprocessable_entity }
              end
            end
          end

          # POST /docs
          # POST /docs.json
          def create
            authorize! :edit, Heb412Gen::Doc
            @doc = Heb412Gen::Doc.new(doc_params)
            if !@doc.nombre && @doc.adjunto_file_name
              @doc.nombre = @doc.adjunto_file_name
            end
            if !@doc.nombremenu && @doc.nombre
              @doc.nombremenu = @doc.nombre
            end
            create_gen(@doc)
          end

          # GET /docs/1/edit
          def edit
            authorize! :edit, Heb412Gen::Doc
          end

          # PATCH/PUT /docs/1
          # PATCH/PUT /docs/1.json
          def update
            authorize! :edit, Heb412Gen::Doc
            respond_to do |format|
              if @doc.update(doc_params)
                ordena_doc
                format.html { 
                  redirect_to @doc, notice: 'Doc actualizado.' 
                }
                format.json { render :show, status: :ok, location: @doc }
              else
                format.html { render :edit }
                format.json { 
                  render json: @doc.errors, status: :unprocessable_entity 
                }
              end
            end
          end

          # DELETE /docs/1
          # DELETE /docs/1.json
          def destroy
            authorize! :edit, Heb412Gen::Doc
            @doc.destroy
            respond_to do |format|
              format.html { 
                redirect_to docs_url, notice: 'Doc eliminado.' 
              }
              format.json { head :no_content }
            end
          end

          def index
            @docs = Heb412Gen::Doc.all
          end

          # Llena una plantilla para multiples registros
          # a partir de una fuente de datos (tabla o vista)
          def self.llena_plantilla_multiple_fd(doc, fd)
            puts "ajdunto_file_name=#{doc.adjunto_file_name}"
            puts "ruta_doc=#{doc.ruta_doc}"
            libro = Rspreadsheet.open(doc.ruta_doc)
            hoja = libro.worksheets(1)
            fila = doc.filainicial
            fd.each do |r|
              doc.campohc.each do |c|
                #byebug
                col = (Heb412Gen::ApplicationHelper::RANGOCOL.
                       find_index(c.columna))+1
                puts "fila=#{fila}, col=#{col}, c.nobmrecampo=#{c.nombrecampo}, r[c.nombrecampo]=#{r[c.nombrecampo]}"
                hoja[fila, col] = r[c.nombrecampo]
              end
              fila += 1
            end 

            n=File.join('/tmp', doc.adjunto_file_name)
            libro.save(n)
            return n
            #send_file n, x_sendfile: true
              #type: 'application/vnd.oasis.opendocument.text',
              #disposition: 'attachment',
              #filename: 'elnombre.ods'

          end

          def impreso
            puts "ajdunto_file_name=#{@doc.adjunto_file_name}"
            puts "ruta_doc=#{@doc.ruta_doc}"
            libro = Rspreadsheet.open(@doc.ruta_doc)
            hoja = libro.worksheets(1)
            fila = @doc.filainicial
            (1..3).each do |r|
              @doc.campohc.each do |c|
                col = (Heb412Gen::ApplicationHelper::RANGOCOL.
                       find_index(c.columna))+1
                puts "fila=#{fila}, col=#{col}, c.nobmrecampo=#{c.nombrecampo}, r=#{r}"
                hoja[fila, col] = fila.to_s + " - " + col.to_s + " - " + 
                  c.nombrecampo
              end
              fila += 1
            end 

            n=File.join('/tmp', @doc.adjunto_file_name)
            libro.save(n)

            send_file n, x_sendfile: true
              #type: 'application/vnd.oasis.opendocument.text',
              #disposition: 'attachment',
              #filename: 'elnombre.ods'
          end

          private
          # Use callbacks to share common setup or constraints between actions.
          def set_doc
            @doc = Doc.find(params[:id])
          end

          # Never trust parameters from the scary internet, only allow the white list through.
          def doc_params
            params.require(:doc).permit(
              :nombre,
              :tipodoc,
              :url,
              :fuente,
              :descripcion,
              :adjunto,
              :vista,
              :nombremenu, 
              :filainicial,
              :campohc_attributes => [
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
