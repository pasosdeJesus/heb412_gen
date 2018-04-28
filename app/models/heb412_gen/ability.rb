# encoding: UTF-8
module Heb412Gen
	class Ability  < Sip::Ability

    BASICAS_PROPIAS = []

    def tablasbasicas 
      Sip::Ability::BASICAS_PROPIAS + 
        Heb412Gen::Ability::BASICAS_PROPIAS - [
          ['Sip', 'pais'],
          ['Sip', 'departamento'],
          ['Sip', 'municipio'],
          ['Sip', 'clase'],
          ['Sip', 'fuenteprensa'],
          ['Sip', 'grupo'],
          #    ['Sip', 'etiqueta'],
          ['Sip', 'oficina'],
          ['Sip', 'tclase'],
          ['Sip', 'tdocumento'],
          ['Sip', 'trelacion'],
          ['Sip', 'tsitio']
      ] 
    end


    BASICAS_ID_NOAUTO = []
    # Hereda basicas_id_noauto de sip
   
    NOBASICAS_INDSEQID =  []
    # Hereda nobasicas_indice_seq_con_id de sip
   
    BASICAS_PRIO = []
    # Hereda tablasbasicas_prio de sip

    CAMPOS_PLANTILLAS_PROPIAS = {
      'Usuario' => {
        campos: [
          'created_at',
          'descripcion',
          'email', 
          'id', 
          'nombre', 
          'nusuario', 
          'rol',
          'updated_at'
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
