# frozen_string_literal: true

module Heb412Gen
  class ModelosController < Msip::ModelosController
    # Sin control de autorización porquue es usada por otras clases
    # que si lo deben implementar
    def importa_dato_gen(datosent, datossal, menserror, registro = nil, opciones = {})
      if registro.nil?
        registro = clase.constantize.new
      elsif registro.class.to_s != clase
        menserror << "  El controlador #{self.class} no puede " +
          "importar #{registro.class} en #{clase}."
      end

      r = registro.importa(datosent, datossal, menserror, opciones)
      r
    end

    # Crea o completa un registro del modelo manejado por el controlador
    # @param datosent Diccionario con datos de entrada
    # @param datossal Diccionario con datos de salida complementarios al registro principal retornado
    # @param registro Objeto del modelo manejado por el controlador parcialmente lleno o por crear o ubicar? (si es nil).
    # @param menserror colchon de errores
    # @param opciones opciones para la importación
    # Si logra crear/ubicar  y completar el registro con los datos que
    # van en datosent retorna el objeto modificado,  de lo contrario retorna
    # nil y aumenta errores en menserror.
    def importa_dato(datosent, datossal, menserror, registro = nil, opciones = {})
      importa_dato_gen(datosent, datossal, menserror, registro, opciones)
    end

    # Complementar importa_dato salvando en base otros datos datossal que
    # requerían que el registro fuese salvado primero
    def complementa_importa_dato(registro, ulteditor_id, datossal,
      menserror, opciones = {})
      puts "OJO complementa_importa_dato, ulteditor_id=#{ulteditor_id}"
      registro.complementa_importa(ulteditor_id, datossal, menserror, opciones)
    end

    # Deserializa para enviar a ActiveJob
    def self.cons_a_fd(cons, colvista = [])
      l = []
      cons.each do |r|
        f = {}
        colvista.each do |c|
          v = ""
          if r.respond_to?(:presenta)
            v = r.presenta(c) # Debe manejar formu.campo
          elsif !r[c].nil?
            v = r[c]
          end
          f[c] = if v.is_a?(Integer)
            v
          elsif r[c].class == BigDecimal
            r[c].to_f
          else
            v.to_s
          end
        end
        l << f
      end
      l
    end

    # Lista de vistas manejadas por este controlador
    # coincide con algunas de app/models/ability.rb
    def vistas_manejadas
      []
    end

    # Prepara lista de plantillas disponibles en base de datos
    # para este controlador
    def index_plantillas_heb412
      @plantillas = [["", ""]]
      @plantillasunr = [["", ""]]
      if vistas_manejadas.length > 0
        @plantillas = Heb412Gen::Plantillahcm
          .where("vista IN (?)", vistas_manejadas).select("nombremenu, id")
          .map { |p| [p.nombremenu, p.id] }
      end
    end

    def index_plantillas
      index_plantillas_heb412
    end

    # Prepara lista de plantillas disponibles en base de datos
    # para este controlador
    def show_plantillas
      @plantillas = [["", ""]]
      if vistas_manejadas.length > 0
        @plantillas = Heb412Gen::Plantilladoc
          .where("vista IN (?)", vistas_manejadas).select("nombremenu, id")
          .map { |p| [p.nombremenu, "#{p.id}.odt"] }
        @plantillas += Heb412Gen::Plantillahcr
          .where("vista IN (?)", vistas_manejadas).select("nombremenu, id")
          .map { |p| [p.nombremenu, "#{p.id}.ods"] }
      end
    end

    # Ordenamiento de hojas de cálculo generadas desde el listado (vista index)
    def self.index_reordenar(registros)
      registros.reorder([:id])
    end

    # Ordenamiento del listado (vista index)
    def index_reordenar(registros)
      self.class.name.constantize.index_reordenar(registros)
    end

    # Genera "vista" de registros por exportar,
    # limitando a los registros cuyas identificaciones ids recibe así
    # como a parametros parsimp.
    # @param plant Id de plantilla
    # @param ids Ids de registros
    # @param modelo Modelo de cada registro
    # @param narch Nombre de archivo que se generará
    # @param parsimp es hash sencillo con algunos de los params de la solicitud:
    # {nombre1: valor1, nombre2: valor2...}
    # @param extension Extensión por generar .ods, .xlsx
    # @param campoid símbolo con el campo de los ids
    # @param params parámetros completos
    def self.vista_listado(plant, ids, modelo, narch, parsimp, extension,
      campoid = :id, params = nil, controlador = nil)
      registros = modelo.where(campoid => ids)
      if respond_to?(:index_reordenar)
        registros = index_reordenar(registros)
      end
      registros
    end

    # Llamada por programa_generacion_listado y modelo para hacer
    # otras personalizadas
    def programa_generacion_listado_int(params, extension, campoid, pl, narch)
      ids = @registros.map(&campoid)

      parsimp = {}
      parsimp[:busfechainicio_ini] = nil
      if params[:filtro][:busfechainicio_localizadaini] &&
          params[:filtro][:busfechainicio_localizadaini] != ""
        parsimp[:busfechainicio_ini] =
          params[:filtro][:busfechainicio_localizadaini]
      end

      parsimp[:busfechainicio_fin] = nil
      if params[:filtro][:busfechainicio_localizadafin] &&
          params[:filtro][:busfechainicio_localizadafin] != ""
        parsimp[:busfechainicio_fin] =
          params[:filtro][:busfechainicio_localizadafin]
      end

      parsimp[:busfechacierre_ini] = nil
      if params[:filtro][:busfechacierre_localizadaini] &&
          params[:filtro][:busfechacierre_localizadaini] != ""
        parsimp[:busfechacierre_ini] =
          params[:filtro][:busfechacierre_localizadaini]
      end

      parsimp[:busfechacierre_fin] = nil
      if params[:filtro][:busfechacierre_localizadafin] &&
          params[:filtro][:busfechacierre_localizadafin] != ""
        parsimp[:busfechacierre_fin] =
          params[:filtro][:busfechacierre_localizadafin]
      end
      cparams = params
      cparams.permit!
      Heb412Gen::GeneralistadoJob.perform_later(
        pl.id,
        @registros.take.class.name, # Permite generar benefactividadpl desde actividad
        self.class.name,
        ids,
        narch,
        parsimp,
        extension,
        campoid,
        cparams,
      )
    end

    # Prepara y lanza tarea en segundo plano para llenar una plantilla
    # con cierta extensión
    # @param extension es extensión de formato por generar comenzando con .
    def programa_generacion_listado(params, extension, campoid = :id)
      if params[:idplantilla].nil? or params[:idplantilla].to_i <= 0 or
          @registros == []
        head(:no_content)
      elsif Heb412Gen::Plantillahcm.where(
        id: params[:idplantilla].to_i,
      ).take.nil?
        head(:no_content)
      else
        pl = Heb412Gen::Plantillahcm.find(
          params[:idplantilla].to_i,
        )
        if vistas_manejadas.include?(pl.vista)
          rarch = File.join(
            "/generados/", File.basename(pl.ruta, ".ods").to_s +
            "-" + DateTime.now.strftime("%Y%m%d%H%M%S")
          ).to_s
          narch = File.join(
            Rails.application.config.x.heb412_ruta,
            rarch,
          )
          puts "narch=#{narch}"
          FileUtils.touch(narch + "#{extension}-0")
          flash[:notice] = "Se programó la generación del archivo " +
            "#{rarch}#{extension}, por favor refresque hasta verlo generado"
          if respond_to?("programa_generacion_listado_int#{pl.id}")
            send(
              "programa_generacion_listado_int#{pl.id}",
              params,
              extension,
              campoid,
              pl,
              narch,
            )
          else
            programa_generacion_listado_int(
              params,
              extension,
              campoid,
              pl,
              narch,
            )
          end
          rutaurl = File.join(
            heb412_gen.sisini_path,
            "/generados",
          ).to_s
          redirect_to(rutaurl, format: "html")
          return
        end
      end
      redirect_to(main_app.root_path, format: "html")
    end

    def index_otros_formatos_campoid
      :id
    end

    # Sobrecarga de Msip
    def index_otros_formatos(format, params)
      format.ods do
        programa_generacion_listado(
          params, ".ods", index_otros_formatos_campoid
        )
      end
      format.pdf do
        programa_generacion_listado(
          params, ".pdf", index_otros_formatos_campoid
        )
      end
      format.xlsx do
        programa_generacion_listado(
          params, ".xlsx", index_otros_formatos_campoid
        )
      end
      format.docx do
        programa_generacion_listado(
          params, ".docx", index_otros_formatos_campoid
        )
      end
    end

    # Responde a botón generar documento
    def fichaimp
      establece_registro
      unless @registro
        return
      end

      puts params
      narchivo = "".dup
      tipomime = "".dup
      npl = params[:idplantilla].to_i
      if !params[:format] || params[:format] == "odt"
        reporte_a = genera_odt(npl, narchivo)
        tipomime = "application/vnd.oasis.opendocument.text"
      elsif params[:format] == "ods"
        reporte_a = genera_ods(npl, narchivo)
        tipomime = "application/vnd.oasis.opendocument.spreadsheet"
      elsif params[:format] == "xlsx"
        reporte_a = genera_xlsx_de_ods(npl, narchivo)
        tipomime = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      end
      # El enlace en la vista debe tener data-turbo=false
      if reporte_a.to_s == ""
        flash.now[:error] = "Problemas al generar plantilla #{npl}"
        redirect_to(main_app.root_path)
      else
        puts "OJO reporte_a=#{reporte_a}, tipomime=#{tipomime}, "\
          "narchivo=#{narchivo}"
        send_file(
          reporte_a, # x_sendfile: true,
          type: tipomime.to_s,
          disposition: "attachment",
          filename: narchivo.to_s,
        )
      end
    end

    # Responde a botón generar PDF
    def fichapdf
      establece_registro
      unless @registro
        return
      end

      narchivo = "".dup
      if !params[:format] || params[:format] == "odt"
        reporte_a = genera_odt(params[:idplantilla].to_i, narchivo)
      elsif params[:format] == "ods"
        reporte_a = genera_ods(params[:idplantilla].to_i, narchivo)
      end
      nase = narchivo.split(".")[0]
      if File.exist?("/tmp/#{nase}.pdf")
        File.delete("/tmp/#{nase}.pdf")
      end
      res = %x(libreoffice --headless --convert-to pdf "#{reporte_a}" --outdir /tmp/)
      puts "OJO res=#{res}, narchivo=#{narchivo}, nase=#{nase}"
      if File.exist?("/tmp/#{nase}.pdf")
        send_file(
          "/tmp/#{nase}.pdf",
          type: "application/pdf",
          disposition: "attachment",
          filename: nase + ".pdf",
        )
      else
        flash.now[:error] = "No se encontró el archivo /tmp/#{nase}.pdf"
        redirect_to(main_app.root_path)
      end
    end

    # Establece variable @registro (igual a @basica)
    # usada por fichaimp y fichapdf
    def establece_registro
      @registro = @basica = nil
      if !params || !params[:id] ||
          clase.constantize.where(id: params[:id]).count != 1
        return
      end

      @registro = @basica = clase.constantize.find(params[:id])
      c2 = clase.demodulize.underscore
      eval("@#{c2} = @registro")
    end

    def genera_odt(plantilla_id, narchivo)
      plantilla = Heb412Gen::Plantilladoc.find(plantilla_id)
      if !plantilla || !plantilla.ruta || plantilla.ruta == ""
        return ""
      end

      narchivo << File.basename(plantilla.ruta)
      report = ::ODFReport::Report.new(
        "#{Rails.root}/public/heb412/#{plantilla.ruta}",
      ) do |r|
        cn = current_ability.campos_plantillas[plantilla.vista][:campos]
        cn.each do |s|
          r.add_field(s, @registro.presenta(s))
        end
        if @registro.respond_to?(:respuestafor) &&
            @registro.respuestafor.respond_to?(:valorcampo) &&
            @registro.respuestafor.valorcampo.each do |vc|
              n = vc.campo.actividadtipo.nombre + "_" + vc.campo.nombre
              n = n.upcase.gsub(/[^A-Z0-9ÁÉÍÓÚÜÑ]/, "_")
              puts "Posible campo #{n} -> #{vc.valor}"
              r.add_field(n, vc.valor)
            end
        end
      end

      ngen = File.join("/tmp", File.basename(plantilla.ruta))
      # byebug
      report.generate(ngen.to_s)

      ngen
    end

    def genera_ods(plantilla_id, narchivo)
      plantilla = Heb412Gen::Plantillahcr.find(plantilla_id)
      unless plantilla
        return
      end

      narchivo << File.basename(plantilla.ruta)
      ngen = Heb412Gen::PlantillahcrController.llena_plantilla_fd(
        plantilla, @registro
      )

      ngen
    end

    def genera_xlsx_de_ods(plantilla_id, narchivo)
      plantilla = Heb412Gen::Plantillahcr.find(plantilla_id)
      unless plantilla
        return
      end
      narchivo = narchivo.dup
      narchivo << File.basename(plantilla.ruta.sub(/.ods$/, ".xlsx"))
      ngen = Heb412Gen::PlantillahcrController.llena_plantilla_fd(
        plantilla, @registro
      )
      ngend = ngen.sub(/.ods$/, ".xlsx")
      if File.exist?(ngend)
        File.delete(ngend)
      end

      res = %x(libreoffice --headless --convert-to xlsx "#{ngen}" --outdir '/tmp')
      puts "OJO res=#{res}"
      ngend
    end
  end
end
