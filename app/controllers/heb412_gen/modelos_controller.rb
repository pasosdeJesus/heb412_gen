# encoding: UTF-8

module Heb412Gen
  class ModelosController < Sip::ModelosController

    # Deserializa para enviar a ActiveJobs
    def cons_a_fd(cons, colvista = [])
      l = []
      cons.each do |r|
        f = {}
        #colmod = r.class.columns.map(&:name)
        #colmod.each do |c|
        #  f[c] = r[c].to_s
        #end
        #colexcvista =  colvista-colmod
        #colexcvista.each do |c|
        colvista.each do |c|
          f[c] = r.presenta(c).to_s
        end
        l << f
      end
      return l
    end


    # Lista de vistas manejadas por este controlador
    # coincide con algunas de app/models/ability.rb
    def vistas_manejadas
      []
    end

    # Prepara lista de plantillas disponibles en base de datos 
    # para este controlador
    def index_plantillas
      @plantillas = [['', '']]
      if vistas_manejadas.length > 0
        @plantillas = Heb412Gen::Plantillahcm.
          where('vista IN (?)', vistas_manejadas).select('nombremenu, id').
          map {|p| [p.nombremenu, p.id]}
      end
    end

    # Prepara lista de plantillas disponibles en base de datos 
    # para este controlador
    def show_plantillas
      @plantillas = [['', '']]
      if vistas_manejadas.length > 0
        @plantillas = Heb412Gen::Plantilladoc.
          where('vista IN (?)', vistas_manejadas).select('nombremenu, id').
          map {|p| [p.nombremenu, p.id]}
      end
    end

    # Genera vista limitando a los registros que recibe
    def self.vista_listado(plant, ids, modelo, narch, 
                busfechainicio_ini, busfechainicio_fin,
                busfechacierre_ini, busfechacierre_fin)
      registros = modelo.where(id: ids)

      return registros
    end

    # Sobrecarga de Sip 
    def index_otros_formatos(format, params)
      format.ods {
        if params[:idplantilla].nil? or params[:idplantilla].to_i <= 0 
          head :no_content 
        elsif Heb412Gen::Plantillahcm.where(
          id: params[:idplantilla].to_i).take.nil?
          head :no_content 
        else
          pl = Heb412Gen::Plantillahcm.find(
            params[:idplantilla].to_i)
          if vistas_manejadas.include?(pl.vista)
            rarch = File.join(
              '/generados/', File.basename(pl.ruta, '.ods').to_s + 
              "-" + DateTime.now.strftime('%Y%m%d%H%M%S')).to_s
            narch = File.join(Rails.application.config.x.heb412_ruta, 
                              rarch)
            puts "narch=#{narch}"
            FileUtils.touch(narch + '.ods-0')
            flash[:notice] = "Se programó la generación del archivo " +
              "#{rarch}.ods, por favor refresque hasta verlo generado"
            ids = @registros.map(&:id)
            rutaurl = File.join(heb412_gen.sisini_path, 
                                '/generados').to_s

            busfechainicio_ini = nil
            if params[:filtro][:busfechainicio_localizadaini] && 
              params[:filtro][:busfechainicio_localizadaini] != ''
              busfechainicio_ini = params[:filtro][:busfechainicio_localizadaini] 
            end

            busfechainicio_fin = nil
            if params[:filtro][:busfechainicio_localizadafin] && 
              params[:filtro][:busfechainicio_localizadafin] != ''
              busfechainicio_fin = params[:filtro][:busfechainicio_localizadafin] 
            end

            busfechacierre_ini = nil
            if params[:filtro][:busfechacierre_localizadaini] && 
              params[:filtro][:busfechacierre_localizadaini] != ''
              busfechacierre_ini = params[:filtro][:busfechacierre_localizadaini] 
            end

            busfechacierre_fin = nil
            if params[:filtro][:busfechacierre_localizadafin] && 
              params[:filtro][:busfechacierre_localizadafin] != ''
              busfechacierre_fin = params[:filtro][:busfechacierre_localizadafin] 
            end
            Heb412Gen::GeneraodsJob.perform_later(
              pl.id, @registros.take.class.name, self.class.name, ids, narch,
              busfechainicio_ini, busfechainicio_fin,
              busfechacierre_ini, busfechacierre_fin)
            redirect_to rutaurl, format: 'html'
            #return
          end
        end
      }
    end



    def fichaimp
      @registro = @basica = clase.constantize.find(params[:id])
      puts params
      narchivo = ''
      report = genera_odf(params[:idplantilla].to_i, narchivo)
      # El enlace en la vista debe tener data-turbolinks=false
      send_data report.generate,
        type: 'application/vnd.oasis.opendocument.text',
        disposition: 'attachment',
        filename: narchivo
    end

    def fichapdf
      @registro = @basica = clase.constantize.find(params[:id])
      narchivo = ''
      report = genera_odf(params[:idplantilla].to_i, narchivo)
      nase = narchivo.split(".")[0]
      report.generate("/tmp/#{narchivo}")
      if File.exist?("/tmp/#{nase}.pdf")
        File.delete("/tmp/#{nase}.pdf")
      end
      res = `libreoffice --headless --convert-to pdf "/tmp/#{narchivo}" --outdir /tmp/`
      puts "OJO res=#{res}, narchivo=#{narchivo}, nase=#{nase}"
      if File.exist?("/tmp/#{nase}.pdf")
        send_file "/tmp/#{nase}.pdf",
        type: 'application/pdf',
          disposition: 'attachment',
          filename: nase + '.pdf'
      else
        flash.now[:error] = "No se encontró el archivo /tmp/#{nase}.pdf"
        redirect_to main_app.root_path
      end
    end

    def genera_odf(plantilla_id, narchivo)
      plantilla = Heb412Gen::Plantilladoc.find(plantilla_id)
      if !plantilla
        return
      end
      narchivo << File.basename(plantilla.ruta)
      report = ODFReport::Report.new(
        "#{Rails.root}/public/heb412/#{plantilla.ruta}") do |r|
        cn = current_ability.campos_plantillas[plantilla.vista][:campos]
        cn.each do |s|
          r.add_field(s, @registro.presenta(s))
        end
        @registro.valorcampoact.each do |vc|
          n = vc.campoact.actividadtipo.nombre + "_" + vc.campoact.nombrecampo
          n = n.upcase.gsub(/[^A-Z0-9ÁÉÍÓÚÜÑ]/, '_')
          puts "Posible campo #{n} -> #{vc.valor}"
          r.add_field(n, vc.valor)
        end
      end

      return report
    end

  end
end
