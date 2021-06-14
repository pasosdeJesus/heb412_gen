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
    initialize_heb412_gen(usuario)
    can :descarga_anexo, Sip::Anexo
    can :contar, Sip::Ubicacion
    can :buscar, Sip::Ubicacion
    can :lista, Sip::Ubicacion
    can :nuevo, Sip::Ubicacion
    if usuario && usuario.rol then
      case usuario.rol 
      when Ability::ROLANALI
        can :manage, Sip::Orgsocial
        can :manage, Sip::Persona
        can [:read, :new, :update, :create, :destroy], Sip::Ubicacion
      when Ability::ROLADMIN
        can :manage, Mr519Gen::Formulario

        can :manage, Sip::Orgsocial
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

