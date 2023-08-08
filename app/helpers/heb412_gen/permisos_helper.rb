# frozen_string_literal: true

module Heb412Gen
  module PermisosHelper
    # Concepto de permisos estilo "GMI - Grupo muy importante" (se parece a
    # una sala VIP que dentro puede tener subsalas aún más VIP)
    #
    # Los administradores y directivos pueden leer y escribir en todas partes.
    # Los demás roles sólo pueden ver directorios y entrar así como descargar
    #   archivos en carpetas que no para GMI, o bien si la carpeta es
    #   exclusiva para uno de los grupos a los que pertenezca el usuario.
    # La carpeta raíz no es exclusiva.
    # Cuando una carpeta (no raíz) se marca como exclusiva para uno o más
    # grupos, todos sus archivos y subcarpetas recursivamente son exclusivas
    # para esos grupos.
    # Cuando se define la exclusividad de una carpeta para uno o más grupos,
    # sólo puede ser entre los grupos permitidos para la carpeta mamá.
    def permiso_ver_leer(ruta, carpeta, usuario)
      if usuario.rol == Ability::ROLADMIN || usuario.rol == Ability::ROLDIR ||
          ruta == "/"
        return true
      end

      carpetabase = carpeta ? ruta : File.dirname(ruta)
      p = carpetabase.split("/")
      (1..p.length - 1).each do |i|
        e = ""
        (1..i).each do |j|
          e += "/" + p[j]
        end
        # byebug
        if Heb412Gen::Carpetaexclusiva.where(carpeta: e).count > 0 &&
            Heb412Gen::Carpetaexclusiva.where(
              carpeta: e,
              grupo: usuario.grupo,
            ).count == 0
          return false
        end
      end
      true
    end
    module_function :permiso_ver_leer
  end
end
