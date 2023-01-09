ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start
require_relative 'dummy/config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
end


PRUEBA_CAMPOHC={
  nombrecampo: 'c',
  columna: 'col',
  fila: 1
}

PRUEBA_CAMPOPLANTILLAHCM = {
  nombrecampo: 'c',
  columna: 'A'
}

PRUEBA_CAMPOPLANTILLAHCR = {
  nombrecampo: 'c',
  columna: 'A',
  fila: 3
}

PRUEBA_CARPETAEXCLUSIVA = {
  carpeta: 'c',
}


PRUEBA_DOC={
  nombre: 'N',
  tipodoc: 'T',
  dirpapa: nil,
  url: 'url',
  fuente: 'fuente',
  descripcion: 'desc',
  created_at: '2023-01-08',
  nombremenu: 'm',
  vista: 'v',
  filainicial: 1,
  ruta: 'r',
  licencia: 'l',
  tdoc_id: nil,
  tdoc_type: nil
}

PRUEBA_GRUPO = {
  id: 1000,
  nombre: "GRUPO1",
  fechacreacion: "2017-04-13",
}

PRUEBA_PLANTILLAHCM = {
  ruta: 'x',
  fuente: 'f',
  licencia: 'l',
  vista: 'v',
  nombremenu: 'n',
  filainicial: 1
}

PRUEBA_PLANTILLAHCR = {
  ruta: 'x',
  fuente: 'f',
  licencia: 'l',
  vista: 'v',
  nombremenu: 'n',
}

