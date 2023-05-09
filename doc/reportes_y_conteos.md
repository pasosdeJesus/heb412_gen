Cuando se tienen reportes basados en tablas con varias decenas de miles de registros (digamos más de 30.000) que deben unirse a otras tablas para exportar datos consolidados a hoja de cálculo, pero que antes de exportarse completos deben presentarse sintetizados en pantalla para permitir filtrar rapidamente sugerimos:

* Emplear una vista materializada rápida de pocas columnas para consultar y filtrar en pantalla
* Emplear la infraestructura de rails y `msip` sobre esa consulta como si fuera una tabla usual aunque sin posibilidad de crear, actualizar o eliminar.
* Para la exportación del consolidado completo a hoja de cálculo crear una segunda consulta que emplee la primera como consulta base y los filtros.
* Emplear la infraestructura de `heb412_gen` para la exportación a hoja de cálculo sobrecargando la función `self.vista_listado` bien con (1) el método flexible pero lento de exportación con plantillas ODS configurables o bien con (2) con el método rápido pero configurable solo por desarrolladores de exportación directa.  


I. Vista materializada base justo con lo que debe presentarse en pantalla y filtro en pantalla

1. Crear un modelo con el nombre de la vista base que además la cree, por ejemplo
  `app/models/sivel2_sjr/consactividadcaso.rb` que incluya: `include Msip::Modelo`

2. En ese modelo en un método `crea_consulta` crear la consulta de manera
que tenga las filas por presentar (no necesariamente  todas las columnas por exportar).

3. Crear un controlador para esa vista que en el método `index` la presente

4. Crear una ruta y agregarla a `config/routes.rb`:

        get '/consactividadcaso' => 'consactividadcaso#index',
          as: :consactividadcaso


II. Segunda vista materializada y exportación

1. Crear un modelo con un nombre por ejemplo con sufijo exportación

2. La consulta de este debe incluir la primera y completar los campos con todos los que se puedan requerir en la exportación, también pueden hacerse métodos que sean llamados por la función presenta --pero mejor sólo para lo excepcional porque son muchisimo más lentos que hacerlo en base de datos.
