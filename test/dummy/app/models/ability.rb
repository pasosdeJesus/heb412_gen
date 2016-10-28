# encoding: UTF-8
class Ability  < Heb412Gen::Ability

  @@acciones_plantillas = {'Listado de Casos' => { campos:
     ['ultimaatencion_mes', 'ultimaatencion_fecha', 
      'contacto_nombres', 'contacto_apellidos', 'contacto_identificacion', 
      'contacto_genero', 'contacto_edad', 'contacto_etnia',
      'beneficiarios_0_5', 'beneficiarios_6_12',
      'beneficiarios_13_17', 'beneficiarios_18_26',
      'beneficiarios_27_59', 'beneficiarios_60_',
      'beneficiarias_0_5', 'beneficiarias_6_12',
      'beneficiarias_13_17', 'beneficiarias_18_26',
      'beneficiarias_27_59', 'beneficiarias_60_',
      'ultimaatencion_derechos', 'ultimaatencion_as_humanitaria',
      'ultimaatencion_as_juridica', 'ultimaatencion_otros_ser_as', 
      'oficina' ],
      controlador: 'Sivel2Sjr::CasosController#index',
      unregistro: false # Son muchos registros debe iterarse
  }
  }

  def self.acciones_plantillas
    @@acciones_plantillas
  end
end

