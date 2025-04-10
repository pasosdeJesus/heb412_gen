# frozen_string_literal: true

module Heb412Gen
  class Ability < Mr519Gen::Ability
    ROLADMIN  = 1
    # ROLINV    = 2
    ROLDIR    = 3
    # ROLCOOR   = 4
    ROLOPERADOR = ROLANALI = 5
    # ROLSIST   = 6

    ROLES = [
      ["Administrador", ROLADMIN], # 1
      ["", 0], # 2
      ["Directivo", ROLDIR], # 3
      ["", 0], # 4
      ["Operador", ROLOPERADOR], # 5
      ["", 0], # 6
    ]

    BASICAS_PROPIAS = []

    def tablasbasicas
      Msip::Ability::BASICAS_PROPIAS +
        Heb412Gen::Ability::BASICAS_PROPIAS
    end

    BASICAS_ID_NOAUTO = []
    # Hereda basicas_id_noauto de msip

    NOBASICAS_INDSEQID = [
      ["heb412_gen", "campohc"],
      ["heb412_gen", "campoplantillahcm"],
      ["heb412_gen", "campoplantillahcr"],
      ["heb412_gen", "carpetaexclusiva"],
      ["heb412_gen", "doc"],
      ["heb412_gen", "formulario_plantillahcr"],
      ["heb412_gen", "plantilladoc"],
      ["heb412_gen", "plantillahcm"],
      ["heb412_gen", "plantillahcr"],
    ]

    # Tablas no básicas pero que tienen índice *_seq_id
    def nobasicas_indice_seq_con_id
      Msip::Ability::NOBASICAS_INDSEQID +
        Mr519Gen::Ability::NOBASICAS_INDSEQID +
        NOBASICAS_INDSEQID
    end

    BASICAS_PRIO = []
    # Hereda tablasbasicas_prio de msip

    CAMPOS_PLANTILLAS_PROPIAS = {
      "Orgsocial" => {
        campos: [
          "actualizado_en",
          "anotaciones",
          "creado_en",
          "direccion",
          "fax",
          "id",
          "nombre",
          "pais",
          Msip::Orgsocial.human_attribute_name(
            :sectoresorgsocial,
          ).downcase.gsub(" ", "_"),
          "telefono",
          "web",
        ],
        controlador: "::OrgsocialesController",
        ruta: "/orgsociales",
      },

      "Persona" => {
        campos: [
          "actualizado_en",
          "apellidos",
          "anionac",
          "centro_poblado",
          "creado_en",
          "departamento",
          "dianac",
          "fechanac_localizada",
          "fechanac",
          "id",
          "mesnac",
          "municipio",
          "nacionalde",
          "numerodocumento",
          "nombres",
          "pais",
          "sexo",
          "tdoc",
          "tdocumento",
        ],
        controlador: "Msip::PersonasController",
        ruta: "/personas",
      },

      "Usuario" => {
        campos: [
          "actualizacion",
          "condensado_de_clave",
          "creacion",
          "correo",
          "descripcion",
          "fechacreacion",
          "fechadeshabilitacion",
          "id",
          "idioma",
          "nombre",
          "nusuario",
          "rol",
        ],
        controlador: "::UsuariosController",
        ruta: "/usuarios",
      },
    }

    def campos_plantillas
      CAMPOS_PLANTILLAS_PROPIAS
    end

    def self.lista_permisos_plantillahcm
      [Heb412Gen::Plantillahcm, Heb412Gen::Campoplantillahcm]
    end

    def self.lista_permisos_plantillahcr
      [Heb412Gen::Plantillahcr, Heb412Gen::Campoplantillahcr]
    end

    # Se definen habilidades con cancancan
    # Util en motores y aplicaciones de prueba
    # En aplicaciones es mejor escribir completo el modelo de autorización
    # para facilitar su análisis y evitar cambios inesperados al actualizar
    # motores
    # @usuario Usuario que hace petición
    def initialize_heb412_gen(usuario = nil)
      initialize_mr519_gen(usuario)

      if usuario && usuario.rol
        can(:read, Heb412Gen::Doc)
        can(:read, Heb412Gen::Plantilladoc)
        can(:read, Heb412Gen::Ability.lista_permisos_plantillahcm)
        can(:read, Heb412Gen::Ability.lista_permisos_plantillahcr)

        case usuario.rol
        when Ability::ROLANALI
        when Ability::ROLADMIN
          can(:manage, Heb412Gen::Doc)
          can(:manage, Heb412Gen::Plantilladoc)
          can(:manage, Heb412Gen::Ability.lista_permisos_plantillahcm)
          can(:manage, Heb412Gen::Ability.lista_permisos_plantillahcr)
          can(:manage, Heb412Gen::Carpetaexclusiva)
        end
      end
    end # initialize_heb412_gen
  end # class
end   # module
