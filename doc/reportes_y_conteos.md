Cuando se tienen reportes basados en tablas con varias decenas de miles de registros (digamos más de 30.000) que deben unirse a otras tablas para exportar datos consolidados a hoja de cálculo, pero que antes de exportarse completos deben presentarse sintetizados en pantalla para permitir filtrar rapidamente sugerimos:

* Emplear una vista materializada rápida de pocas columnas para consultar y filtrar en pantalla
* Emplear la infraestructura de rails y `msip` sobre esa consulta como si fuera una tabla usual aunque sin posibilidad de crear, actualizar o eliminar --pero que se vaya limitando y refrescando a medida que se aplican nuevos filtros
* Para la exportación del consolidado completo a hoja de cálculo emplear una segunda consulta que emplee la primera como consulta base (ya filtrada).
* Emplear la infraestructura de `heb412_gen` para la exportación a hoja de cálculo sobrecargando la función `self.vista_listado` bien con (1) el método flexible pero lento de exportación con plantillas ODS configurables o bien con (2) con el método rápido pero configurable solo por desarrolladores de exportación directa.  


I. Vista materializada base y filtro en pantalla

1. Crear un modelo con el nombre de la vista base que además la cree, por ejemplo
  `app/models/sivel2_sjr/consactividadcaso.rb` que incluya: `include Msip::Modelo`

2. En ese modelo en un método `crea_consulta` crear la consulta de manera
que tenga las filas por presentar (no necesariamente  todas las columnas por exportar).

3. Crear un controlador para esa vista que en el método `index` la presente

4. Crear una ruta y agregarla a `config/routes.rb`:

        get '/consactividadcaso' => 'consactividadcaso#index',
          as: :consactividadcaso

