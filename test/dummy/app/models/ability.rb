class Ability  < Heb412Gen::Ability


  def acciones_plantillas
  end

  # Se definen habilidades con cancancan
  # Util en motores y aplicaciones de prueba
  # En aplicaciones es mejor escribir completo el modelo de autorización
  # para facilitar su análisis y evitar cambios inesperados al actualizar
  # motores
  # @usuario Usuario que hace petición
  def initialize(usuario = nil)
    initialize_heb412_gen(usuario)
  end

end

