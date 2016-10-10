# encoding: UTF-8
module Heb412Gen
	class Ability  < Sip::Ability

    BASICAS_PROPIAS = [
    ]
    @@tablasbasicas = Sip::Ability::BASICAS_PROPIAS + BASICAS_PROPIAS - [
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

    BASICAS_ID_NOAUTO = []
    # Hereda @@basicas_id_noauto de sip
   
    NOBASICAS_INDSEQID =  []
    # Hereda @@nobasicas_indice_seq_con_id de sip
   
    BASICAS_PRIO = []
    # Hereda @@tablasbasicas_prio de sip

    # Ver documentacion de este metodo en app/models/sip/ability de sip
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
end
