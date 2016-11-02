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
            if !File.exists? Rails.application.config.x.ruta_sisarch
              flash[:error] = "No existe ruta #{Rails.application.config.x.ruta_sisarch}"
              redirect_to '/'
              return
            end
            rr = Rails.application.config.x.ruta_sisarch.join(
              "./" + @ruta)
            logger.debug "~ rr=#{rr.to_s}/"
            presenta_contenido rr
          end

          # Crear carpeta
          def nueva_carpeta
            byebug
            if !limpia_ruta(params[:nuevo][:ruta]) ||
              params[:nuevo][:nombre].nil?
              redirect_to '/'
              return
            end
            nombre = params[:nuevo][:nombre]
            nombre.gsub!(/[^0-9A-Za-záéíóú_ÁÉÍÓÚñÑüÜ]/, '')

            rr1 = Rails.application.config.x.ruta_sisarch.join(
              "./#{@ruta}")
            rr2 = rr1.join(nombre)
            logger.debug "~ rr2=#{rr2.to_s}/"
            FileUtils.mkdir rr2.to_s,  mode: 0700
            presenta_contenido rr1
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
