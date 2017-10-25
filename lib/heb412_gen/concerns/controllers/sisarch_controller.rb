# encoding: UTF-8

require 'cgi'

module Heb412Gen
  module Concerns
    module Controllers
      module SisarchController

        # En general todas las funciones esperan un paramétro con el
        # directorio (ruta) del archivo y otro con el nombre.
        extend ActiveSupport::Concern

        included do

          # Nombre de archivo o directorio
          # conesp permitir espacios?
          def sanea_nombre(nombre, conesp=true)
            c = CGI::unescape(nombre)
            if conesp 
              re = /[^0-9A-Za-záéíóú_ÁÉÍÓÚñÑüÜ .]/
            else
              re = /[^0-9A-Za-záéíóú_ÁÉÍÓÚñÑüÜ.]/
            end
            r = c.gsub(re, '')
            return r
          end

          # Establece @ruta
          def limpia_ruta(ruta)
            if ruta.nil? || !ruta.starts_with?('arch')
              return false
            end
            @ruta = CGI::unescape(ruta)
            @ruta.sub!(/^arch\/?/, '/')
            @ruta.gsub!('\.\.+', '.')
            @ruta.gsub!('//', '/')
            @ruta.gsub!(/[^0-9A-Za-záéíóú_ÁÉÍÓÚñÑüÜ .\/]/, '')
            return true
          end

          # Presenta contenido de una ruta real que corresponde a @ruta
          # Supone que @ruta ya está definido
          # modhistorial indica si la ruta debe agregarse al historial de
          # navegación del navegador que emplea el usuario
          def presenta_contenido(rr, modhistorial = true)
            @leeme = nil
            @dir = []
            eo = Dir.entries(rr.to_s).sort
            eo.each do |a|
              if a == '.'
                next
              end
              if @ruta == "/" && a == ".."
                next
              end
              estadof = File::Stat.new(rr.join(a).to_s)
              if a == 'LEEME.md' && estadof.ftype == 'file'
                @leeme = File.read(rr.join(a))
                next
              end
              ruta_sa = File.join(@ruta, a).to_s
              puts "a=#{a}, ruta_sa=#{ruta_sa}"
              @dir << {
                nombre: a,
                ruta: ruta_sa,
                estado: estadof,
                plantillashcm: Heb412Gen::Plantillahcm.where(
                  ruta: ruta_sa[1..-1]).pluck(:id, :vista, :nombremenu)
              }
            end
            @modhistorial = modhistorial
            if request.env['HTTP_ACCEPT'].index('text/javascript')
              render 'heb412_gen/sisarch/refresca'
            else
              render layout: 'application' 
            end
          end

          # Ver carpeta
          def index
            authorize! :read, Heb412Gen::Doc
            # Ignoramos el reconocimiento de parametros de rails
            # pues busca poner formato con base en extensión
            rp = URI.decode(request.path)
            rp.force_encoding(Encoding::UTF_8)
            ir = rp.index(params[:ruta])
            ruta = rp[ir..-1]
            if !limpia_ruta(ruta)
              redirect_to Rails.configuration.relative_url_root
              return
            end
            logger.debug "~ ruta=#{@ruta}"
            if Rails.application.config.x.heb412_ruta.nil? ||
              Rails.application.config.x.heb412_ruta.to_s == "{}"
              flash[:error] = 
                "No existe variable Rails.application.config.x.heb412_ruta"
              redirect_to Rails.configuration.relative_url_root
              return
            end
            if !File.exists? Rails.application.config.x.heb412_ruta
                flash[:error] = 
                  "No se ha creado #{Rails.application.config.x.heb412_ruta}"
              redirect_to Rails.configuration.relative_url_root
              return
            end
            rr = Rails.application.config.x.heb412_ruta.join(
              "./" + @ruta)
            logger.debug "~ rr=#{rr.to_s}/"
            if params[:descarga]
              ar = params[:descarga].gsub(/[^-0-9A-Za-záéíóú_ÁÉÍÓÚñÑüÜ .]/, '')
              arr = rr.join(ar)
              if !File.exists?(arr)
                flash[:error] = "No existe ruta #{Rails.application.config.x.heb412_ruta}"
                redirect_to Rails.configuration.relative_url_root
                return
              end
              send_file arr, x_sendfile: true
              return
            else
              presenta_contenido(rr, true)
            end
          end


          # Crear carpeta
          def nueva_carpeta
            authorize! :manage, Heb412Gen::Doc
            if !limpia_ruta(params[:nueva][:ruta]) ||
              params[:nueva][:nombre].nil?
              redirect_to Rails.configuration.relative_url_root
              return
            end
            nombre = sanea_nombre(params[:nueva][:nombre])

            rr1 = Rails.application.config.x.heb412_ruta.join(
              "./#{@ruta}")
            rr2 = rr1.join(nombre)
            logger.debug "~ rr1=#{rr1.to_s}, rr2=#{rr2.to_s}/"
            FileUtils.mkdir rr2.to_s,  mode: 0700
            @heb412_modhistorial = false
            presenta_contenido(rr1, false)
          end
          
          # Crear archivo
          def nuevo_archivo
            authorize! :manage, Heb412Gen::Doc
            if !limpia_ruta(params[:nuevo][:ruta]) ||
              params[:nuevo][:archivo].nil?
              redirect_to Rails.configuration.relative_url_root
              return
            end
            byebug
            nombre = sanea_nombre(params[:nuevo][:archivo].original_filename)

            rr1 = Rails.application.config.x.heb412_ruta.join(
              "./#{@ruta}")
            rr2 = rr1.join(nombre)
            logger.debug "~ rr2=#{rr2.to_s}"

            io = params[:nuevo][:archivo]
            File.open(rr2, 'wb') do |file|
              file.write(io.read)
            end
            #presenta_contenido rr1
            @heb412_modhistorial = false
            nurl = File.join(Rails.configuration.relative_url_root, 
                             'sis/arch/', @ruta)
            redirect_to nurl
          end
 
          # eliminar archivo
          def eliminar_archivo
            authorize! :manage, Heb412Gen::Doc
            if params[:arc].nil? || params[:ruta].nil? || 
              !limpia_ruta(params[:ruta]) 
              redirect_to Rails.configuration.relative_url_root
              return
            end
            nombre = sanea_nombre(params[:arc])
            rr1 = Rails.application.config.x.heb412_ruta.join(
              "./#{@ruta}")
            rr2 = rr1.join(nombre)
            logger.debug "~ por eliminar archivo rr1=#{rr1.to_s}, rr2=#{rr2.to_s}"

            File.delete(rr2)
            presenta_contenido(rr1, false)
          end
 
           # eliminar directorio
          def eliminar_directorio
            authorize! :manage, Heb412Gen::Doc
            if params[:dir].nil? || params[:ruta].nil? || 
              !limpia_ruta(params[:ruta]) 
              redirect_to Rails.configuration.relative_url_root
              return
            end
            dir = sanea_nombre(params[:dir])
            rr1 = Rails.application.config.x.heb412_ruta.join(
              "./#{@ruta}")
            rr2 = rr1.join(dir)
            logger.debug "~ por eliminar directorio rr2=#{rr2.to_s}"

            FileUtils.rmdir(rr2)
            presenta_contenido(rr1, false)
          end

          def actleeme
            authorize! :manage, Heb412Gen::Doc
            if params[:actleeme].nil? || params[:actleeme][:ruta].nil? || 
              !limpia_ruta(params[:actleeme][:ruta]) 
              redirect_to Rails.configuration.relative_url_root
              return
            end
            rr1 = Rails.application.config.x.heb412_ruta.join(
              "./#{@ruta}")
            rr2 = rr1.join('LEEME.md')
            logger.debug "~ por remplazar LEEME.md rr2=#{rr2.to_s}"
            File.open(rr2.to_s, 'w') { |file| 
              file.write(params[:actleeme][:leeme]) 
            }

            @heb412_modhistorial = false
            nurl = File.join(Rails.configuration.relative_url_root, 
                             'sis/arch/', @ruta)
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
