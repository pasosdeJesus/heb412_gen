# Manejo de campos compuestos

Un campo compuesto es de la forma __formulario__.__campo__

Por ejemplo en `cor1440_gen` una persona puede ser beneficiaria de uno o más
proyectos y tener caracterizaciones (formularios) de los que lo requieran.

Una caracterización recolecta datos adicionales de los beneficiarios
de un proyecto (acorde a requerimientos del proyecto).

Estos datos compuestos pueden servir para exportar y para importar información.

## Exportar información

### Agregar funcionalidad a controladores descendientes de Heb412Gen::ModelosController

En un controlador que ya llene plantillas siendo descendiente de
`Heb412Gen::ModelosController` pueden manejarse así:

1. Modificando tablas y modelos para darle sentido al campo compuesto
   asociando uno o más formularios a cada registro que maneja el controlador.

2.  sobrecargar `asegura_camposdinamicos` que debe ser llamada cuando se edita
    un registro para asegurar que se crean las respuestas a formulario 
    necesarias (en el ejemplo de persona añade las caracterizaciones
    que hagan falta --o retira las que sobren-- de acuerdo a los proyectos
    donde sea beneficiaria).

3. sobrecargar `self.valor_campo_compuesto(registro, campo)` que recibe un campo 
    compuesto de la forma __formulario__.__campo__ y retorna 
   su valor (buscando si el formulario es caracterización y si está
   respondido el valor que corresponde al __campo__).



### Agregar funcionalidad a controladores descendientes de Sip::Modelo

Además de darle sentido a los campos compuesto asociando uno o más formularios
a cada registro que maneje el controlado, lo mínimo típicamente será:

1. Haga el controlador descendiente de `Heb412Gen::ModelosController` (que a su 
   vez es descendiente de `Sip::ModelosController`)

2. Sobrecargue la función `presenta` de cada modelo que se presentará para
   presentar la información correcta.

3. En caso de que la plantilla tenga campos compuestos, sobrecargue en el 
   controlador la función `self.valor_campo_compuesto(registro, campo)`
   que recibe un campo compuesto de la forma __formulario__.__campo__ y retorna 
   su valor (buscando el formulario apropiado, el campo en el mismo, la respuesta
   que corresponde al registro y retorna el valor por presentar.

4. Agregue un botón en la vista index para generar en el formato que requiere
   'ods', 'xlsx' y que al pulsarse llame la función javascript 
   `heb412_gen_completa_generarap(elema, idselplantilla, idruta, rutagenera, formato)`

Si esto no basta para su caso puede que le sirva la descripción que sigue.

### Flujo de operación

- Un usuario final pulsa un botón que llama la función 
   `heb412_gen_completa_generarap(elema, idselplantilla, idruta, rutagenera, formato)`
  esta función modifica el campo action del fomurlaio para solicitar el formato que
  recibe y continuará cargandolo.

- El controlador del index que se ejecute como respuesta al envio del formulario 
  (descendiente de `Heb412Gen::ModelosController`) se recomienda que llame (y
  sobrecargue de requerirse)  la función 
  `programa_generacion_listado(params, extension)` que preparará datos y lanzará 
  tarea en segundo plano para llenar la plantilla.

- La función por omisión `programa_generacion_listados(params, extension)` 
  emplea la variable `@registros` (típica de un `index` de un controlador descendiente
  de `Sip::ModelosController`) y los parámetros para llenar la plantilla
  con la extensión dada.
  Antes de lanzar la tarea prepara una copia de la plantilla en un archivo
  por llenar, extrae la lista de identificaciones  de `@registros`
  y ejecuta en segundo plano el llenado llamando la tarea
  `Heb412Gen::GeneralistadoJob`

- La tarea `Heb412Gen::GeneralistadoJob.perform(plantilla_id, nomclase,nomcontrolador, ids, narch, parsimp, extension)`
  recibe mediante el método `vista_listado` del controlado que recibe (o 
  en su defecto de `Heb412Gen::ModelosController`), bien la plantilla llena o bien 
  datos para llenarla.
  Si recibe datos para llenarla, y si nos son arreglo los convierte a arreglo 
  mediante la función `self.cons_a_fd(cons, colvista)` del controlador que 
  llamó y llena la plantilla mediante  la función 
  `Heb412Gen::PlantillahcmController.llena_plantilla_multiple_fd(plant, fd)`
  y va informando el porcentaje de progreso aprovechando el `yield` de esa
  función.

- Por su parte es por omisión durante la conversión a arreglo que hace
  `self.cons_a_fd(cons, colvista)` que puede modificarse más lo que se
  presentará.  La función por omisión convierte cada dato de manera condicional asi:
  - Si es campo compuesto (por tener `.`) llama la función del controlado 
    `valor_campo_compuesto(registro, campo)`
  - Si el registro tiene método presenta lo usa pasando el nombre del campo
    como atributo --y es fácil sobrecargar ese método en el modelo.
  - Si no tenía método `presenta` (por ejemplo si la fuente de registros es una vista)
    trata de extraer el campo directo del registro.






