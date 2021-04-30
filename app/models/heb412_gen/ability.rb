# encoding: UTF-8
module Heb412Gen
	class Ability  < Sip::Ability

    ROLADMIN  = 1
    #ROLINV    = 2
    ROLDIR    = 3
    #ROLCOOR   = 4
    ROLOPERADOR = ROLANALI  = 5
    #ROLSIST   = 6

    ROLES = [
      ["Administrador", ROLADMIN],  # 1
      ["", 0], # 2
      ["Directivo", ROLDIR], # 3
      ["", 0], # 4
      ["Operador", ROLOPERADOR], # 5
      ["", 0], #6
    ]


    BASICAS_PROPIAS = []

    def tablasbasicas 
      Sip::Ability::BASICAS_PROPIAS + 
        Heb412Gen::Ability::BASICAS_PROPIAS
    end

    BASICAS_ID_NOAUTO = []
    # Hereda basicas_id_noauto de sip

    NOBASICAS_INDSEQID =  [
      ['heb412_gen', 'campoplantillahcm'],
      ['heb412_gen', 'plantilladoc'],
      ['heb412_gen', 'plantillahcm'],
      ['heb412_gen', 'plantillahcr']
    ]
    # Hereda nobasicas_indice_seq_con_id de sip

    BASICAS_PRIO = []
    # Hereda tablasbasicas_prio de sip

    CAMPOS_PLANTILLAS_PROPIAS = {
      'Actorsocial' => {
        campos: [
          'actualizado_en',
          'anotaciones',
          'creado_en',
          'direccion',
          'fax',
          'id', 
          'nombre',
          'pais',
          Sip::Actorsocial.human_attribute_name(
            :sectoresactores).downcase.gsub(' ', '_'),
          'telefono', 
          'web'
        ],
        controlador: '::ActoressocialesController',
        ruta: '/actoressociales'
      },

      'Persona' => {
        campos: [
          'actualizado_en',
          'apellidos',
          'anionac', 
          'centro_poblado',
          'creado_en',
          'departamento',
          'dianac',
          'fechanac_localizada',
          'fechanac',
          'id',
          'mesnac',
          'municipio',
          'nacionalde',
          'numerodocumento', 
          'nombres', 
          'pais', 
          'sexo', 
          'tdoc',
          'tdocumento',
        ],
        controlador: 'Sip::PersonasController',
        ruta: '/personas'
      },

      'Usuario' => {
        campos: [
          'actualizacion',
          'condensado_de_clave', 
          'creacion',
          'correo', 
          'descripcion',
          'fechacreacion',
          'fechadeshabilitacion',
          'id', 
          'idioma',
          'nombre', 
          'nusuario', 
          'rol'
        ],
        controlador: '::UsuariosController',
        ruta: '/usuarios'
      }
    }
          
    def campos_plantillas 
      CAMPOS_PLANTILLAS_PROPIAS
    end


    # Autorizacion con CanCanCan
    def initialize_heb412_gen(usuario = nil)
      if !usuario || usuario.fechadeshabilitacion || !usuario.rol
        return
      end
      can :read, Heb412Gen::Doc
      can :read, Heb412Gen::Plantilladoc
      can :read, Heb412Gen::Plantillahcm
      can :read, Heb412Gen::Plantillahcr

      case usuario.rol 
      when Ability::ROLANALI

      when Ability::ROLADMIN
        can :manage, Heb412Gen::Carpetaexclusiva
        can :manage, Heb412Gen::Doc
        can :manage, Heb412Gen::Plantilladoc
        can :manage, Heb412Gen::Plantillahcm
        can :manage, Heb412Gen::Plantillahcr
      end
    end


  end # class
end   # module
