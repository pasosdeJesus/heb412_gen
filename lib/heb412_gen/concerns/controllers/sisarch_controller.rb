# encoding: UTF-8

module Heb412Gen
  module Concerns
    module Controllers
      module SisarchController

        extend ActiveSupport::Concern

        included do

          # Establece @ruta
          def limpia_ruta(ruta)
            if ruta.nil? || !ruta.starts_with?('arch')
              return false
            end
            @ruta = ruta.sub(/^arch\/?/, '/')
            @ruta.gsub!('\.\.+', '.')
            @ruta.gsub!('//', '/')
            return true
          end

          # Presenta contenido de una ruta real que corresponde a @ruta
          # Supone que @ruta ya está definido
          def presenta_contenido(rr)
            @dir = []
            Dir.foreach(rr.to_s) do |a|
              if a == '.'
                next
              end
              if @ruta == "/" && a == ".."
                next
              end
              puts "a=#{a}"
              @dir << {
                nombre: a,
                ruta: File.join(@ruta,  a).to_s,
                estado: File::Stat.new(rr.join(a).to_s)
              }
            end
            respond_to do |format|
              format.html { render layout: 'application' }
              format.js { render 'heb412_gen/sisarch/refresca' }
            end
          end

          # Ver carpeta
          def index
            if !limpia_ruta(params[:ruta])
              redirect_to '/'
              return
            end
            logger.debug "~ ruta=#{@ruta}"
            if Rails.application.config.x.heb412_ruta.nil? ||
              Rails.application.config.x.heb412_ruta.to_s == "{}"
              flash[:error] = 
                "No existe variable Rails.application.config.x.heb412_ruta"
              redirect_to '/'
              return
            end
            if !File.exists? Rails.application.config.x.heb412_ruta
                flash[:error] = 
                  "No se ha creado #{Rails.application.config.x.heb412_ruta}"
              redirect_to '/'
              return
            end
            rr = Rails.application.config.x.heb412_ruta.join(
              "./" + @ruta)
            logger.debug "~ rr=#{rr.to_s}/"
            if params[:descarga]
              ar = params[:descarga].gsub(/[^-0-9A-Za-záéíóú_ÁÉÍÓÚñÑüÜ.]/, '')
              arr = rr.join(ar)
              if !File.exists?(arr)
                flash[:error] = "No existe ruta #{Rails.application.config.x.heb412_ruta}"
                redirect_to '/'
                return
              end
              send_file arr, x_sendfile: true
              return
            else
              presenta_contenido rr
            end
          end


          # Crear carpeta
          def nueva_carpeta
            if !limpia_ruta(params[:nueva][:ruta]) ||
              params[:nueva][:nombre].nil?
              redirect_to '/'
              return
            end
            nombre = params[:nueva][:nombre]
            nombre.gsub!(/[^0-9A-Za-záéíóú_ÁÉÍÓÚñÑüÜ]/, '')

            rr1 = Rails.application.config.x.heb412_ruta.join(
              "./#{@ruta}")
            rr2 = rr1.join(nombre)
            logger.debug "~ rr2=#{rr2.to_s}/"
            FileUtils.mkdir rr2.to_s,  mode: 0700
            presenta_contenido rr1
          end
          
          # Crear archivo
          def nuevo_archivo
            if !limpia_ruta(params[:nuevo][:ruta]) ||
              params[:nuevo][:archivo].nil?
              redirect_to '/'
              return
            end
            nombre = params[:nuevo][:archivo].original_filename
            nombre.gsub!(/[^-0-9A-Za-záéíóú_ÁÉÍÓÚñÑüÜ.]/, '')

            rr1 = Rails.application.config.x.heb412_ruta.join(
              "./#{@ruta}")
            rr2 = rr1.join(nombre)
            logger.debug "~ rr2=#{rr2.to_s}"

            io = params[:nuevo][:archivo]
            File.open(rr2, 'wb') do |file|
              file.write(io.read)
            end
            #presenta_contenido rr1
            nurl = File.join(Rails.configuration.relative_url_root, 'sis/arch/',
                             @ruta)
            redirect_to nurl
          end
 
          private
          # Use callbacks to share common setup or constraints between actions.
          def set_sisarch
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
