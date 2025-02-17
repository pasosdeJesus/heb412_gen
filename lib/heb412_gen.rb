# frozen_string_literal: true

require "heb412_gen/engine"

# Motor para manejar archivos en nube y para exportar un registro
# o un conjunto pequeño de registros en plantillas de hojas de cálculo.
#
# La información exportada en plantillas resulta en reportes altamente
# flexibles y prácticos porque un administrador puede modificar las plantillas
# y la forma en la que se llenan con la información exportada sin necesidad de
# modificar las fuentes de la aplicación. Esta flexibilidad, se logra con el
# formato abierto ODS (nativo de LibreOffice).
#
# Como la exportación con este método es demorada, no se recomienda para
# conjuntos de registros medianos o grandes --para esos sugerimos
# implementar reportes particulares en las fuentes en formatos XLSX (medianos)
# y CSV (masivos).
module Heb412Gen
end
