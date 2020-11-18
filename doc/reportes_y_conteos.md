Para hacer exportables a hoja de cálculo con más facilidad reportes y conteos
a la vez que se presentan en pantalla sugerimos emplear una vista materializada
y la infraestructura de rails y sip sobre la misma como si fuera una tabla usual:

1. Crear un modelo con el nombre de la vista que además la cree, por ejemplo
  `app/models/sivel2_sjr/consactividadcaso.rb` que incluya:
include Sip::Modelo

2. En ese modelo en un método crea_consulta crear la consulta de manera
que tenga las filas por presentar (no necesariamente  todas las columnas).

3. Crear un controlador para esa vista que en el método index la presente

4. Crear una ruta y agregarla a la interfaz
config/routes.rb
get '/consactividadcaso' => 'consactividadcaso#index',
  as: :consactividadcaso

