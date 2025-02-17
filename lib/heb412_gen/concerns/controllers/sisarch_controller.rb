# frozen_string_literal: true

require "cgi"

module Heb412Gen
  module Concerns
    module Controllers
      module SisarchController
        # En general todas las funciones esperan un paramétro con el
        # directorio (ruta) del archivo y otro con el nombre.
        extend ActiveSupport::Concern

        included do
          def er_buen_nombre
            /[^-0-9A-Za-záéíóú_ÁÉÍÓÚñÑüÜ.]/
          end

          def er_buen_nombre_conesp
            /[^-0-9A-Za-záéíóú_ÁÉÍÓÚñÑüÜ .]/
          end

          def er_buen_nombre_conesp_conbarra
            %r{[^-0-9A-Za-záéíóú_ÁÉÍÓÚñÑüÜ ./]}
          end

          # Sanea nombre de archivo o directorio, elimina espacios al comienzo
          #   y final
          # conesp permitir espacios?
          def sanea_nombre(nombre, conesp = true)
            c = CGI.unescape(nombre)
            re = if conesp
              er_buen_nombre_conesp
            else
              er_buen_nombre
            end
            r = c.gsub(re, "")
            r = r.strip
            r
          end

          # Establece @ruta
          def limpia_ruta(ruta)
            if ruta.nil? || !ruta.starts_with?("arch")
              return false
            end

            @ruta = CGI.unescape(ruta)
            @ruta.sub!(%r{^arch/?}, "/")
            @ruta.gsub!('\.\.+', ".")
            @ruta.gsub!("//", "/")
            @ruta.gsub!(er_buen_nombre_conesp_conbarra, "")
            true
          end

          # Presenta contenido de una ruta real que corresponde a @ruta
          # Supone que @ruta ya está definido
          # modhistorial indica si la ruta debe agregarse al historial de
          # navegación del navegador que emplea el usuario
          def presenta_contenido(rr, modhistorial = true)
            @leeme = nil
            @dir = []
            cotejador = TwitterCldr::Collation::Collator.new(
              Rails.configuration.i18n.default_locale,
            )
            eo = Dir.entries(rr.to_s).sort do |x, y|
              cotejador.compare(x, y)
            end
            eo.each do |a|
              if a == "."
                next
              end
              if @ruta == "/" && a == ".."
                next
              end

              # Puede haber cambios en sistema de archivos entre el Dir.entries
              # y este punto (por ejemplo al genera hoja de calculo podría
              # renombrar muy rapido)
              estadof = nil
              if File.exist?(rr.join(a).to_s)
                estadof = File::Stat.new(rr.join(a).to_s)
              end
              if a == "LEEME.md" && estadof.ftype == "file"
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
                  ruta: ruta_sa[1..-1],
                ).pluck(:id, :vista, :nombremenu),
              }
            end
            @modhistorial = modhistorial
            if request.env["HTTP_ACCEPT"].index("text/javascript")
              render("heb412_gen/sisarch/refresca")
            else
              render(layout: "application")
            end
          end

          # Ver carpeta
          def index
            authorize!(:read, Heb412Gen::Doc)
            if current_usuario &&
                ::Ability.respond_to?(:externo?) && ::Ability.externo?(current_usuario)
              if request.path != "/sis/arch/generados"
                return
              end
            end
            # Ignoramos el reconocimiento de parametros de rails
            # pues busca poner formato con base en extensión
            rp = URI.decode_www_form_component(request.path, Encoding::UTF_8)
            ir = rp.index(params[:ruta])
            ruta = rp[ir..-1]
            unless limpia_ruta(ruta)
              redirect_to(Rails.configuration.relative_url_root)
              return
            end
            logger.debug("~ ruta=#{@ruta}")
            if Rails.application.config.x.heb412_ruta.nil? ||
                Rails.application.config.x.heb412_ruta.to_s == "{}"
              flash[:error] =
                "No existe variable Rails.application.config.x.heb412_ruta"
              redirect_to(Rails.configuration.relative_url_root)
              return
            end
            unless File.exist?(Rails.application.config.x.heb412_ruta)
              flash[:error] =
                "No se ha creado #{Rails.application.config.x.heb412_ruta}"
              redirect_to(Rails.configuration.relative_url_root)
              return
            end
            rr = Rails.application.config.x.heb412_ruta.join(
              "./" + @ruta,
            )
            logger.debug("~ rr=#{rr}/")
            if params[:descarga]
              ar = params[:descarga].gsub(er_buen_nombre_conesp, "")
              arr = rr.join(ar)
              unless File.exist?(arr)
                flash[:error] = "No existe ruta #{Rails.application.config.x.heb412_ruta}"
                redirect_to(Rails.configuration.relative_url_root)
                return
              end
              send_file(arr, x_sendfile: true)
              nil
            else
              presenta_contenido(rr, true)
            end
          end

          # Crear carpeta
          def nueva_carpeta
            authorize!(:create, Heb412Gen::Doc)
            if !params || !params[:nueva] ||
                !params[:nueva][:ruta] ||
                !limpia_ruta(params[:nueva][:ruta]) ||
                params[:nueva][:nombre].nil?
              redirect_to(Rails.configuration.relative_url_root)
              return
            end
            nombre = sanea_nombre(params[:nueva][:nombre])

            rr1 = Rails.application.config.x.heb412_ruta.join(
              "./#{@ruta}",
            )
            rr2 = rr1.join(nombre)
            logger.debug("~ rr1=#{rr1}, rr2=#{rr2}/")
            FileUtils.mkdir(rr2.to_s, mode: 0o700)
            @heb412_modhistorial = false
            presenta_contenido(rr1, false)
          end

          # Crear archivo
          def nuevo_archivo
            authorize!(:create, Heb412Gen::Doc)
            if !params || !params[:nuevo] ||
                !params[:nuevo][:ruta] ||
                !limpia_ruta(params[:nuevo][:ruta]) ||
                params[:nuevo][:archivo].nil?
              redirect_to(Rails.configuration.relative_url_root)
              return
            end
            nombre = sanea_nombre(params[:nuevo][:archivo].original_filename)

            rr1 = Rails.application.config.x.heb412_ruta.join(
              "./#{@ruta}",
            )
            rr2 = rr1.join(nombre)
            logger.debug("~ rr2=#{rr2}")

            io = params[:nuevo][:archivo]
            File.open(rr2, "wb") do |file|
              file.write(io.read)
            end
            # presenta_contenido rr1
            @heb412_modhistorial = false
            nurl = File.join(
              Rails.configuration.relative_url_root,
              "sis/arch/",
              @ruta,
            )
            redirect_to(nurl)
          end

          # eliminar archivo
          def eliminar_archivo
            # if params && params[:ruta] && params[:ruta] != "arch/generados"
            # authorize!(:destroy, Heb412Gen::Doc)
            # end
            # Se permite eliminación del directorio generados por parte de
            # cualquier usuario --no conviene por ejemplo de no autenticados
            if params[:arc].nil? || params[:ruta].nil? ||
                !limpia_ruta(params[:ruta])
              redirect_to(Rails.configuration.relative_url_root)
              return
            end
            nombre = sanea_nombre(params[:arc])
            rr1 = Rails.application.config.x.heb412_ruta.join(
              "./#{@ruta}",
            )
            rr2 = rr1.join(nombre)
            logger.debug("~ por eliminar archivo rr1=#{rr1}, rr2=#{rr2}")

            File.delete(rr2)
            presenta_contenido(rr1, false)
          end

          # eliminar directorio
          def eliminar_directorio
            authorize!(:destroy, Heb412Gen::Doc)
            if params[:dir].nil? || params[:ruta].nil? ||
                !limpia_ruta(params[:ruta])
              redirect_to(Rails.configuration.relative_url_root)
              return
            end
            dir = sanea_nombre(params[:dir])
            rr1 = Rails.application.config.x.heb412_ruta.join(
              "./#{@ruta}",
            )
            rr2 = rr1.join(dir)
            logger.debug("~ por eliminar directorio rr2=#{rr2}")

            FileUtils.rmdir(rr2)
            presenta_contenido(rr1, false)
          end

          def actleeme
            authorize!(:manage, Heb412Gen::Doc)
            if params[:actleeme].nil? || params[:actleeme][:ruta].nil? ||
                !params[:actleeme][:leeme] ||
                !limpia_ruta(params[:actleeme][:ruta])
              redirect_to(Rails.configuration.relative_url_root)
              return
            end
            rr1 = Rails.application.config.x.heb412_ruta.join(
              "./#{@ruta}",
            )
            rr2 = rr1.join("LEEME.md")
            logger.debug("~ por remplazar LEEME.md rr2=#{rr2}")
            File.open(rr2.to_s, "w") do |file|
              file.write(params[:actleeme][:leeme])
            end

            @heb412_modhistorial = false
            nurl = File.join(
              Rails.configuration.relative_url_root,
              "sis/arch/",
              @ruta,
            )
            redirect_to(nurl)
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
              campohc_attributes: [
                :id,
                :nombrecampo,
                :columna,
              ],
            )
          end
        end
      end
    end
  end
end
