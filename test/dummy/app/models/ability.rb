# encoding: UTF-8
class Ability  < Heb412Gen::Ability

  # Autorizacion con CanCanCan
  def initialize(usuario = nil)
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

