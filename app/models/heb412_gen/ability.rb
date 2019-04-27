# encoding: UTF-8
module Heb412Gen
	class Ability  < Sip::Ability

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
          'sectores',
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

	end
end
