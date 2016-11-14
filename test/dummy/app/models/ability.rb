# encoding: UTF-8
class Ability  < Heb412Gen::Ability

  @@acciones_plantillas = {'Listado de casos' => { campos:
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

  @@tablasbasicas = Sip::Ability::BASICAS_PROPIAS + 
    Heb412::Ability::BASICAS_PROPIAS - [
    ['Sip', 'pais'],
    ['Sip', 'departamento'],
    ['Sip', 'municipio'],
    ['Sip', 'clase'],
    ['Sip', 'fuenteprensa'],
    ['Sip', 'etiqueta'],
    ['Sip', 'oficina'],
    ['Sip', 'tclase'],
    ['Sip', 'tdocumento'],
    ['Sip', 'trelacion'],
    ['Sip', 'tsitio']
  ] 

  # Ver documentacion de este metodo en 
  #   spec/dummy/app/models/sip/ability del motor sip
  def initialize(usuario)
    # Sin autenticación puede consultarse información geográfica 

    can :read, [Sip::Pais, Sip::Departamento, Sip::Municipio, Sip::Clase]
    if !usuario || usuario.fechadeshabilitacion
      return
    end
    can :contar, Sip::Ubicacion
    can :buscar, Sip::Ubicacion
    can :lista, Sip::Ubicacion
    can :descarga_anexo, Sip::Anexo
    can :nuevo, Sip::Ubicacion
    if usuario && usuario.rol then
      can :read, Heb412Gen::Doc
      case usuario.rol 
      when Ability::ROLANALI
        can :manage, Sip::Persona
        can :read, Sip::Ubicacion
        can :new, Sip::Ubicacion
        can [:update, :create, :destroy], Sip::Ubicacion
      when Ability::ROLADMIN
        can :manage, Sip::Ubicacion
        can :manage, Heb412Gen::Doc
        can :manage, Sip::Persona
        can :manage, Usuario
        can :manage, :tablasbasicas
        @@tablasbasicas.each do |t|
          c = Ability.tb_clase(t)
          can :manage, c
        end
      end
    end
  end

end

