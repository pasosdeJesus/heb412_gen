# encoding: UTF-8
class Ability  < Heb412Gen::Ability

  def acciones_plantillas
  end

  # Autorizacion con CanCanCan
  def initialize(usuario = nil)
    # Sin autenticación puede consultarse información geográfica 

    can :read, [Sip::Pais, Sip::Departamento, Sip::Municipio, Sip::Clase]
    if !usuario || usuario.fechadeshabilitacion
      return
    end
    can :descarga_anexo, Sip::Anexo
    can :contar, Sip::Ubicacion
    can :buscar, Sip::Ubicacion
    can :lista, Sip::Ubicacion
    can :nuevo, Sip::Ubicacion
    if usuario && usuario.rol then
      can :read, Heb412Gen::Doc
      can :read, Heb412Gen::Plantilladoc
      can :read, Heb412Gen::Plantillahcm
      can :read, Heb412Gen::Plantillahcr
      case usuario.rol 
      when Ability::ROLANALI
        can :manage, Sip::Actorsocial
        can :manage, Sip::Persona
        can [:read, :new, :update, :create, :destroy], Sip::Ubicacion
      when Ability::ROLADMIN
        can :manage, Heb412Gen::Doc
        can :manage, Heb412Gen::Plantilladoc
        can :manage, Heb412Gen::Plantillahcm
        can :manage, Heb412Gen::Plantillahcr

        can :manage, Sip::Actorsocial
        can :manage, Sip::Persona
        can :manage, Sip::Ubicacion

        can :manage, ::Usuario
        can :manage, :tablasbasicas
        tablasbasicas.each do |t|
          c = Ability.tb_clase(t)
          can :manage, c
        end
      end
    end
  end

end

