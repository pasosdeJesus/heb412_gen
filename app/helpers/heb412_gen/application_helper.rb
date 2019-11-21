# encoding: UTF-8
module Heb412Gen
  module ApplicationHelper

    include Sip::PaginacionAjaxHelper

    MAXCOL = 'AMJ' # Máxima en gnumeric
    RANGOCOL = ('A'..MAXCOL).to_a

    def er_buen_nombre
      /[^-0-9A-Za-záéíóú_ÁÉÍÓÚñÑüÜ.]/
    end
    module_function :er_buen_nombre

    def er_buen_nombre_conesp
      /[^-0-9A-Za-záéíóú_ÁÉÍÓÚñÑüÜ .]/
    end
    module_function :er_buen_nombre_conesp

    def er_buen_nombre_conesp_conbarra
      /[^-0-9A-Za-záéíóú_ÁÉÍÓÚñÑüÜ .\/]/
    end
    module_function :er_buen_nombre_conesp_conbarra

    # Sanea nombre de archivo o directorio, elimina espacios al comienzo 
    #   y final
    # conesp permitir espacios?
    def sanea_nombre(nombre, conesp=true)
      c = CGI::unescape(nombre)
      if conesp 
        re = er_buen_nombre_conesp
      else
        re = er_buen_nombre
      end
      r = c.gsub(re, '')
      r = r.strip
      return r
    end
    module_function :sanea_nombre

  end
end
