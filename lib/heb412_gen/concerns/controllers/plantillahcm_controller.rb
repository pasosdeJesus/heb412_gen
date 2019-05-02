# encoding: UTF-8

module Heb412Gen
  module Concerns
    module Controllers
      module PlantillahcmController

        extend ActiveSupport::Concern

        included do
          include ActionView::Helpers::AssetUrlHelper
          include Sip::FormatoFechaHelper
          include Sip::ModeloHelper
  
          before_action :set_plantillahcm, only: [:edit, :update, :destroy, 
                                         :show, :impreso]
          load_and_authorize_resource  class: Heb412Gen::Plantillahcm

          @vista= nil
          attr_accessor :form_f

          # Vuelve a pintar asociación de campos con base en elección 
          # de controlador
          def pintacampos
            @plantillahcm = Heb412Gen::Plantillahcm.new
            if params[:vista]
              vista = Sip::Ubicacion.connection.quote_string(
                params[:vista] ).strip
              ab = ::Ability.new
              if ab.campos_plantillas[vista]
                @plantillahcm.vista = vista 
                @vista = vista
                respond_to do |format|
                  format.html {
                    render partial: 'form_divcampos_plantillahcm',
                      layout: false, locals: { vista: @vista }
                  }
                  format.js {
                    render partial: 'form_divcampos_plantillahcm',
                      layout: false, locals: { vista: @vista }
                  }

                end
              end
            end
          end

          def clase
            'Heb412Gen::Plantillahcm'
          end

          def atributos_show
            ["id", "ruta", "fuente", "licencia", "vista", 
             "nombremenu", "filainicial"]
          end

          def atributos_index
            ["id", "vista", "nombremenu", "ruta", "licencia", "filainicial"]
          end

          def index_reordenar(c)
            c.reorder([:vista, :nombremenu])
          end

          # GET /plantillahcm/nueva
          def new
            authorize! :edit, Heb412Gen::Plantillahcm
            @plantillahcm = Heb412Gen::Plantillahcm.new
            @plantillahcm.vista = 'Usuario'
            @vista = nil
            render :new, layout: 'layouts/application'
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
            authorize! :edit, Heb412Gen::Plantillahcm
            @plantillahcm = Heb412Gen::Plantillahcm.new(plantillahcm_params)
            if !@plantillahcm.nombremenu && @plantillahcm.ruta
              @plantillahcm.nombremenu = File.basename(@plantillahcm.ruta)
            end
            create_gen(@plantillahcm)
          end

          # GET /plantillahcm/1/edit
          def edit
            authorize! :edit, Heb412Gen::Plantillahcm
            render :edit, layout: 'layouts/application'
          end

          # PATCH/PUT /plantillahcm/1
          # PATCH/PUT /plantillahcm/1.json
          def update
            authorize! :edit, Heb412Gen::Plantillahcm
            @vista = @plantillahcm.vista
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
            authorize! :edit, Heb412Gen::Plantillahcm
            @plantillahcm.destroy
            respond_to do |format|
              format.html { 
                redirect_to Rails.configuration.relative_url_root,
                  notice: 'Plantillahcm eliminado.' 
              }
              format.json { head :no_content }
            end
          end

          # Llena una plantilla para multiples registros
          # a partir de una fuente de datos (tabla, vista o arreglo de objetos)
          def self.llena_plantilla_multiple_fd(plantillahcm, fd)
            ruta = File.join(Rails.application.config.x.heb412_ruta, 
                             plantillahcm.ruta).to_s
            puts "ruta=#{ruta}"
            libro = Rspreadsheet.open(ruta)
            hoja = libro.worksheets(1)
            fila = plantillahcm.filainicial
            total = fd.count
            fd.each do |r|
              plantillahcm.campoplantillahcm.each do |c|
                next if !c.columna || c.columna =='' || !c.nombrecampo || c.nombrecampo == ''
                col = (Heb412Gen::ApplicationHelper::RANGOCOL.find_index(c.columna))+1
                v = r[c.nombrecampo.to_sym].nil? ?
                  r[c.nombrecampo] :
                  r[c.nombrecampo.to_sym]
                if !v.is_a? Integer
                  v = v.to_s
                end

                puts "fila=#{fila}, col=#{col}, c.nobmrecampo=#{c.nombrecampo}, r[c.nombrecampo]=#{v}"
                hoja[fila, col] = v
              end
              fila += 1
              yield(total, fila - plantillahcm.filainicial) if block_given?
            end 

            n=File.join('/tmp', File.basename(plantillahcm.ruta))
            libro.save(n)

            return n
            #send_file n, x_sendfile: true
              #type: 'application/vnd.oasis.openplantillahcmument.text',
              #disposition: 'attachment',
              #filename: 'elnombre.ods'

          end


          def self.convierte_a_extension_esperada(nfuente, ndest, extension)
            if extension == '.ods'
              FileUtils.mv(nfuente, "#{ndest}#{extension}")
            elsif extension == '.pdf'
              if File.exist?("#{nfuente}.pdf")
                File.delete("#{nfuente}.pdf")
              end
              dir = File.dirname(ndest)
              bn = File.basename(ndest)
              FileUtils.mv(nfuente, "/tmp/#{bn}")
              res = `libreoffice --headless --convert-to pdf "/tmp/#{bn}" --outdir #{dir}`
              puts "OJO res=#{res}, nfuente=#{nfuente}, dir=#{dir}, bn=#{bn}"
              File.delete("/tmp/#{bn}")

            elsif extension == '.xlsx'
              if File.exist?("#{nfuente}.xlsx")
                File.delete("#{nfuente}.xlsx")
              end
              dir = File.dirname(ndest)
              bn = File.basename(ndest)
              FileUtils.mv(nfuente, "/tmp/#{bn}")
              res = `libreoffice --headless --convert-to xlsx "/tmp/#{bn}" --outdir #{dir}`
              puts "OJO res=#{res}, nfuente=#{nfuente}, dir=#{dir}, bn=#{bn}"
              File.delete("/tmp/#{bn}")
            end
            puts "Fin de generación de #{ndest}"
          end

          def self.fila_en_blanco(hoja, numfila, maxcol)
            col='A'
            while hoja[numfila, col].nil? && col<=maxcol
              col=col.next
            end
            return col > maxcol
          end

          # Llena una plantilla para multiples registros
          # a partir de errores en un archivo con la misma plantilla que
          # intenta importar
          def self.llena_plantilla_multiple_importadatos(plantillahcm, 
                                                         controlador,
                                                         modelo,
                                                         narchent)
            rutasal = File.join(Rails.application.config.x.heb412_ruta, 
                             plantillahcm.ruta).to_s
            puts "rutaent=#{rutasal}"
            librosal = Rspreadsheet.open(rutasal)
            hojasal = librosal.worksheets(1)

            filainicial = plantillahcm.filainicial

            filasal = filainicial

            libroent = Rspreadsheet.open(narchent)
            hojaent = libroent.worksheets(1)
      
            colerror = "A"
            if plantillahcm.campoplantillahcm.count > 0 
              pc = plantillahcm.campoplantillahcm.pluck(:columna).map {|l|
                Heb412Gen::ApplicationHelper::RANGOCOL.
                  find_index(l)
              }
              colerror = Heb412Gen::ApplicationHelper::RANGOCOL[pc.max + 1]
            end
              
            puts "colerror=#{colerror}"
            # En total calculamos total de filas en archivo de entrada
            total = filainicial
            if self.fila_en_blanco(hojaent, total, colerror)
              puts "No hay datos"
              # No hay datos
              #return
            end
            total2 = filainicial + 1
            
            while !self.fila_en_blanco(hojaent, total2, colerror)
              total = total2
              total2 *= 2
            end
            puts "total2=#{total2}"

            # Invariante hojaent.row[total] esta lleno 
            # y hojaent[total2] esta vacio
            while total < total2 
              m = (total + total2) / 2
              if total == m
                break
              elsif self.fila_en_blanco(hojaent, m, colerror)
                total2 = m
              else
                total = m
              end
            end

            filaent = 0 
            puts "total=#{total}"
            hojaent.rows.each do |fila|
              filaent += 1
              puts "filaent=#{filaent}, fila[1]=#{fila[1]}"
              if filaent < filainicial
                next 
              end
              if self.fila_en_blanco(hojaent, filaent, colerror)
                break
              end
              dreg = {}
              plantillahcm.campoplantillahcm.each do |c|
                if !c.columna || c.columna =='' || !c.nombrecampo || 
                  c.nombrecampo == ''
                  next
                end
                dreg[c.nombrecampo.to_sym] = fila[c.columna]
                if fila[c.columna] && fila[c.columna].class.to_s == 'Float' &&
                  fila[c.columna] == fila[c.columna].to_i
                  dreg[c.nombrecampo.to_sym] = fila[c.columna].to_i
                else
                  dreg[c.nombrecampo.to_sym] = fila[c.columna]
                end
                # Aqui podrían ponerse ayudadores generales para la
                # conversión dependiendo del tipo del campo
              end
              # Ayudadores particulares y el que sabe como crear el 
              # registro en la base de datos
              menserror = ''
              datossal = {}
              registro = controlador.importa_dato(dreg.clone, datossal, menserror)
              if !registro.nil? && menserror == ''
                if registro.validate()
                  registro.save
                  if registro.errors.messages && 
                    registro.errors.messages.count > 0
                    menserror << " Se guardo en base de datos con identificacion #{registro.id}, se sugiere no volver a importar sino arreglar en base: " + registro.errors.messages.to_s
                  end
                  controlador.complementa_importa_dato(
                    registro, datossal, menserror)
                else
                  if registro.errors.messages
                    menserror << " " + registro.errors.messages.to_s
                  end
                end
              end
              if menserror != ''
                plantillahcm.campoplantillahcm.each do |c|
                  if !c.columna || c.columna == '' || !c.nombrecampo || 
                    c.nombrecampo == ''
                    next
                  end
                  v = dreg[c.nombrecampo.to_sym]
                  if !v.is_a? Integer
                    v = v.to_s
                  end
                  col = (Heb412Gen::ApplicationHelper::RANGOCOL.
                         find_index(c.columna))+1
                  hojasal[filasal, col] = v
                end
                hojasal[filasal, colerror] = menserror
                filasal += 1
              end
              yield(total, filaent - plantillahcm.filainicial) if block_given?
            end 

            n=File.join('/tmp', File.basename(plantillahcm.ruta))
            librosal.save(n)

            return n
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

          def importadatos
            if params && params[:filtro] &&
              params[:filtro][:plantillahcm_id] && params[:filtro][:archivo]

              if params[:filtro][:plantillahcm_id].to_i <= 0 
                puts "Id de plantilla no valido #{params[:filtro][:plantillahcm_id]}"
                head :no_content 
                return
              end
              if Heb412Gen::Plantillahcm.where(
                id: params[:filtro][:plantillahcm_id].to_i).take.nil?
                head :no_content 
                  puts "No se encuentra plantilla #{params[:filtro][:plantillahcm_id]}"
                return
              end

              nombre = Heb412Gen::ApplicationHelper.
                sanea_nombre(params[:filtro][:archivo].original_filename)

              rr1 = Rails.application.config.x.heb412_ruta.join("./generados/")
              rr2 = rr1.join(nombre)
              logger.debug "~ rr2=#{rr2.to_s}"
              io = params[:filtro][:archivo]
              File.open(rr2, 'wb') do |file|
                file.write(io.read)
              end

              pl = Heb412Gen::Plantillahcm.
                find(params[:filtro][:plantillahcm_id].to_i)
              ab = current_ability ? current_ability : ::Ability.new
              if ab.campos_plantillas[pl.vista].nil?
                head :no_content 
                puts "No se puede manejar vista #{pl.vista}"
                return
              end
              controlador = ab.campos_plantillas[pl.vista][:controlador].
                constantize
              authorize! :edit, controlador.new.clase.constantize
              rarch = File.join(
                '/generados/', File.basename(nombre, '.ods').to_s + 
                "-" + DateTime.now.strftime('%Y%m%d%H%M%S')
              ).to_s
              narch = File.join(Rails.application.config.x.heb412_ruta, 
                                rarch)
              puts "narch=#{narch}"
              extension = '.ods'
              FileUtils.touch(narch + "#{extension}-0")
              flash[:notice] = 
                "Se programó la generación del archivo con problemas de 
                   importación #{rarch}#{extension}, por favor refresque 
                   hasta verlo generado, después examine los errores que 
                   indique, solucionelos e importelo."
              rutaurl = File.join(heb412_gen.sisini_path, 
                                  '/generados').to_s

              Heb412Gen::ImportalistadoJob.perform_later(
                pl.id, controlador.to_s, rr2.to_s, narch, extension)
              redirect_to rutaurl, format: 'html'
              return
            end
            render 'importadatos', layout: 'application'
          end

          private
          # Use callbacks to share common setup or constraints between actions.
          def set_plantillahcm
            @plantillahcm = Plantillahcm.find(params[:id])
          end

          # Never trust parameters from the scary internet, only allow the white list through.
          def plantillahcm_params
            params.require(:plantillahcm).permit(
              :filainicial,
              :fuente,
              :licencia,
              :nombremenu, 
              :ruta,
              :vista,
              :campoplantillahcm_attributes => [
                :id,
                :nombrecampo,
                :columna,
                :_destroy
              ]
            )
          end
        end

      end
    end
  end
end
