# encoding: UTF-8

module Heb412Gen
  class ModelosController < Sip::ModelosController

    # Deserializa para enviar a ActiveJobs
    def self.cons_a_fd(cons, colvista = [])
      l = []
      cons.each do |r|
        f = {}
        colvista.each do |c|
          v = ''
          if r.respond_to?(:presenta)
            v = r.presenta(c)
          elsif !r[c].nil?
            v = r[c]
          end
          if v.is_a? Integer
            f[c] = v
          else
            f[c] = v.to_s
          end
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
      @plantillasunr = [['', '']]
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
          map {|p| [p.nombremenu, "#{p.id.to_s}.odt"]}
        @plantillas += Heb412Gen::Plantillahcr.
          where('vista IN (?)', vistas_manejadas).select('nombremenu, id').
          map {|p| [p.nombremenu, "#{p.id.to_s}.ods"]}
      end
    end

    # Genera vista limitando a los registros que recibe
    # parsimp es hash sencillo con algunos de los params de la solicitud: 
    # {nombre1: valor1, nombre2: valor2...}
    def self.vista_listado(plant, ids, modelo, narch, parsimp)
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

            parsimp = {}
            parsimp[:busfechainicio_ini] = nil
            if params[:filtro][:busfechainicio_localizadaini] && 
              params[:filtro][:busfechainicio_localizadaini] != ''
              parsimp[:busfechainicio_ini] = 
                params[:filtro][:busfechainicio_localizadaini] 
            end

            parsimp[:busfechainicio_fin] = nil
            if params[:filtro][:busfechainicio_localizadafin] && 
              params[:filtro][:busfechainicio_localizadafin] != ''
              parsimp[:busfechainicio_fin] = 
                params[:filtro][:busfechainicio_localizadafin] 
            end

            parsimp[:busfechacierre_ini] = nil
            if params[:filtro][:busfechacierre_localizadaini] && 
              params[:filtro][:busfechacierre_localizadaini] != ''
              parsimp[:busfechacierre_ini] = 
                params[:filtro][:busfechacierre_localizadaini] 
            end

            parsimp[:busfechacierre_fin] = nil
            if params[:filtro][:busfechacierre_localizadafin] && 
              params[:filtro][:busfechacierre_localizadafin] != ''
              parsimp[:busfechacierre_fin] = 
                params[:filtro][:busfechacierre_localizadafin] 
            end
            Heb412Gen::GeneraodsJob.perform_later(
              pl.id, @registros.take.class.name, self.class.name, ids, narch,
              parsimp)
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
      tipomime = ''
      npl = params[:idplantilla].to_i
      if !params[:format] || params[:format] == 'odt'
        reporte_a = genera_odt(npl, narchivo)
        tipomime = 'application/vnd.oasis.opendocument.text'
      elsif params[:format] == 'ods'
        reporte_a = genera_ods(npl, narchivo)
        tipomime = 'application/vnd.oasis.opendocument.spreadsheet'
      end
      # El enlace en la vista debe tener data-turbolinks=false
      if reporte_a == ''
        flash.now[:error] = "Problemas al generar plantilla #{npl}"
      else
        send_file reporte_a, #x_sendfile: true,
          type: tipomime,
          disposition: 'attachment',
          filename: narchivo
      end
    end


    def fichapdf
      @registro = @basica = clase.constantize.find(params[:id])
      narchivo = ''
      if !params[:format] || params[:format] == 'odt'
        reporte_a = genera_odt(params[:idplantilla].to_i, narchivo)
      elsif params[:format] == 'ods'
        reporte_a = genera_ods(params[:idplantilla].to_i, narchivo)
      end
      nase = narchivo.split(".")[0]
      if File.exist?("/tmp/#{nase}.pdf")
        File.delete("/tmp/#{nase}.pdf")
      end
      res = `libreoffice --headless --convert-to pdf "#{reporte_a}" --outdir /tmp/`
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


    def genera_odt(plantilla_id, narchivo)
      plantilla = Heb412Gen::Plantilladoc.find(plantilla_id)
      if !plantilla || !plantilla.ruta || plantilla.ruta == ''
        return ''
      end
      narchivo << File.basename(plantilla.ruta)
      report = ::ODFReport::Report.new(
        "#{Rails.root}/public/heb412/#{plantilla.ruta}") do |r|
        cn = current_ability.campos_plantillas[plantilla.vista][:campos]
        cn.each do |s|
          r.add_field(s, @registro.presenta(s))
        end
        if @registro.respond_to?(:valorcampoact)
          @registro.valorcampoact.each do |vc|
            n = vc.campoact.actividadtipo.nombre + "_" + vc.campoact.nombrecampo
            n = n.upcase.gsub(/[^A-Z0-9ÁÉÍÓÚÜÑ]/, '_')
            puts "Posible campo #{n} -> #{vc.valor}"
            r.add_field(n, vc.valor)
          end
        end
      end

      ngen =File.join('/tmp', File.basename(plantilla.ruta))
      #byebug
      report.generate(ngen.to_s)

      return ngen
    end


    def genera_ods(plantilla_id, narchivo)
      plantilla = Heb412Gen::Plantillahcr.find(plantilla_id)
      if !plantilla
        return
      end
      narchivo << File.basename(plantilla.ruta)
      ngen = Heb412Gen::PlantillahcrController.llena_plantilla_fd(
        plantilla, @registro)

      return ngen
    end


  end
end
