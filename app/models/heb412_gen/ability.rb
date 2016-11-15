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

    def acciones_plantillas 
      {'Listado de casos' => 
       { 
         campos: [
           'ultimaatencion_mes', 'ultimaatencion_fecha', 
           'contacto_nombres', 'contacto_apellidos', 
           'contacto_identificacion', 
           'contacto_genero', 'contacto_edad', 'contacto_etnia',
           'beneficiarios_0_5', 'beneficiarios_6_12',
           'beneficiarios_13_17', 'beneficiarios_18_26',
           'beneficiarios_27_59', 'beneficiarios_60_',
           'beneficiarias_0_5', 'beneficiarias_6_12',
           'beneficiarias_13_17', 'beneficiarias_18_26',
           'beneficiarias_27_59', 'beneficiarias_60_',
           'ultimaatencion_derechos', 'ultimaatencion_as_humanitaria',
           'ultimaatencion_as_juridica', 'ultimaatencion_otros_ser_as', 
           'oficina' 
         ],
         controlador: 'Sivel2Sjr::CasosController#index',
         unregistro: false # Son muchos registros debe iterarse
       }
      }
    end

	end
end
