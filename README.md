# Motor heb412_gen para manejar nube de documentos y plantillas (hojas de cálculo .ods y documentos .odt)


[![Revisado por Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com) Pruebas y seguridad:[![Estado Construcción](https://gitlab.com/pasosdeJesus/heb412_gen/badges/main/pipeline.svg)](https://gitlab.com/pasosdeJesus/heb412_gen/-/pipelines?page=1&scope=all&ref=main) [![Clima del Código](https://codeclimate.com/github/pasosdeJesus/heb412_gen/badges/gpa.svg)](https://codeclimate.com/github/pasosdeJesus/heb412_gen) [![Cobertura de Pruebas](https://codeclimate.com/github/pasosdeJesus/heb412_gen/badges/coverage.svg)](https://codeclimate.com/github/pasosdeJesus/heb412_gen)

![Logo de heb412_gen](https://gitlab.com/pasosdeJesus/heb412_gen/-/raw/main/test/dummy/app/assets/images/logo.jpg)

Este es el motor principal de la aplicación (https://gitlab.com/pasosdeJesus/heb412)[Heb412] 
que maneja una nube de documentos y plantillas ods y odt

Aplican practicamente las mismas instrucciones de otros motores genérico
basados en msip, ver por ejemplo:
	https://gitlab.com/pasosdeJesus/sal7711_gen

Las funcionalidades que provee al momento de este escrito son:

1. Nube de documentos
2. Exportación de información
   1. Exportación de un sólo registro a una plantilla .ods
   2. Exportación de un sólo registro a una plantilla .odt
   3. Exportación de un conjunto de registros a una plantilla .ods (estilo listado)
3. Importación de información
   1. Importación de un conjunto de registros desde un listado .ods 

La exportación e importación requieren la previa configuración de la nube.

## 1. Configure gemas, javascript y base de datos

Este motor opera sobre [msip](https://gitlab.com/pasosdeJesus/msip) y [mr519_gen](https://gitlab.com/pasosdeJesus/mr519_gen)

En su Gemfile asegure tener:

        gem 'rspreadsheet'
        gem 'redcarpet'

        gem 'msip', 
          git: 'https://gitlab.com/pasosdeJesus/heb412_gen.git'
        gem 'mr519_gen', 
          git: 'https://gitlab.com/pasosdeJesus/mr519_gen.git'
        gem 'heb412_gen', 
          git: 'https://gitlab.com/pasosdeJesus/heb412_gen.git'


Incluya el motor javascript en su `app/assets/javascript/application.js` 
   por ejemplo después de `//= require msip/motor` agregue:
```
//= require heb412_gen/motor
```
   y despúes de `msip_prepara_eventos_comunes...` agregue:
```
heb412_gen_prepara_eventos_comunes(root);
```

Ejecute migraciones que agregarán las tablas necesarias
```
bin/rails db:migrate
```

## 2. Configure su aplicación para proveer Nube

### 2.1 Directorio
Cree un directorio que será la raíz del sistema de archivos y que
debe poder ser escrito por el usuario que ejecute la aplicación, e.g
```
	mkdir public/heb412/
```

### 2.2 Configurar directorio en aplicación
Configure esa ruta en su aplicación en ```config/application.rb``` con

        config.x.heb412_ruta = Pathname(
          ENV.fetch('HEB412_RUTA', Rails.root.join('public', 'heb412').to_s)
        )

y en su archivo `.env` algo como:

        if (test "$HEB412_RUTA" = "") then {
          export HEB412_RUTA=${DIRAP}/public/heb412
        } fi;


### 2.3 Menú
Agregue un menú o enlaces a los urls de la nube por ejemplo en
   ```app/views/layouts/application```:

        <%= menu_item "Nube", heb412_gen.sisini_path %>

### 2.4 Configurar rutas
En ```config/routes.rb```

        mount Heb412Gen::Engine, at: '/', as: 'heb412_gen'

## 3. Configure su aplicación para utilizar llenadores de plantillas

Hay 3 tipos de llenadores de plantillas:
- Para llenar una plantilla ODS con datos de un listado (vista index),
  que se supone puede demorarse en generar una conjunto grande de datos

- Para llenar una plantilla ODS con datos de un resumen (vista show), 
  que suponemos se genera rápido.

- Para llenar una plantilla ODT con datos de un resumen (vista show),
  que suponemos se genera rápido.

Los más desarrollados son los 2 primeros (de hecho recomendamos no usar el tercero).

### 3.1 Relacione disponibilidad de campos exportables/importables

Agregue en el archivo `app/models/ability.rb` la relación de campos 
   que un controlador puede dar a una plantilla en la función
   ```campos_plantillas```. Por ejemplo el modelo `Actividad` con controlador 
    `Cor1440Gen::ActividadesController` que se presenta en la ruta `/actividades`
    podría publicar disponibilidad de campos `id`, `fecha` y otros así:


        CAMPOS_PLANTILLAS_PROPIAS = {
          'Actividad' => { 
            campos: [
              'id', 'fecha', 'responsable', 'nombre', 
              'areas', 'subareas', 'convenios_financieros', 
              'actividades_de_convenio', 'objetivo', 'poblacion'
            ],
            controlador: 'Cor1440Gen::ActividadesController',
            ruta: '/actividades'
          }
        }

        def campos_plantillas 
          Heb412Gen::Ability::CAMPOS_PLANTILLAS_PROPIAS.
          clone.merge(CAMPOS_PLANTILLAS_PROPIAS)
        end

Vea un ejemplo más completo en 
<https://gitlab.com/pasosdeJesus/cor1440/-/blob/master/app/models/ability.rb>

Si alguna plantilla sólo debe ser para un registro puede emplear el 
atributo ```solo_registro: true```.
Si una plantilla debe ser sólo para un listado emplee el atributo 
```solo_multiple: true```.
Puede ver un ejemplo de este  último caso en 
    <https://gitlab.com/pasosdeJesus/si_jrscol/-/blob/master/app/models/ability.rb>

### 3.2 Permisos para gestionar y/o para llenar plantillas

En `app/models/ability.rb` de permiso a un usuario (digamos administrador) 
  para manejar plantillas:

        can :manage, Heb412Gen::Doc
        can :manage, Heb412Gen::Plantillahcr
        can :manage, Heb412Gen::Plantilladoc

  y a usuarios que necesiten generarlas por lo menos de lectura

        can :read, Heb412Gen::Doc
        can :manage, Heb412Gen::Plantillahcm
        can :manage, Heb412Gen::Plantillahcr
        can :manage, Heb412Gen::Plantilladoc

### 3.3 Menú para gestionar plantillas

Cree una entrada en el menú que permite acceder a la funcionalidad
de definir una plantilla. Por ejemplo en 
```app/views/layouts/application.html.erb```
algo  como:

        <% if can? :manage, Heb412Gen::Plantillahcm %>
          <%= opcion_menu "Definir plantillas para listados en hojas de calculo",
            heb412_gen.plantillashcm_path, desplegable: true %>
       <% end %>


### 3.4 Configure una vista `index` que llenará un listado .ods

Será simple cuando inicialmente el controlador sea descendiente de 
`Msip::ModelosController` y emplee la función por omisión `index` y 
la respectiva vista automática pues en tal caso basta que haga el 
controlador descendiente de `Heb412Gen::ModelosController` y que añada
la función `vistas_manejadas` con un listado de las vistas que el 
controlador maneja de entre las referenciadas por la función 
`campos_plantillas` de `ability.rb`.  Por ejemplo:

        ...
        class ActoressocialesController < Heb412Gen::ModelosController
          ...
          def vistas_manejadas
            ['Actorsocial']
          end
          ...
        end


Después debe inicar la aplicación y un administrador debe gestionar una o
varias plantillas en listado  `.ods` para la vista en cuestión.

Después de esto, cuando un usuario con permiso de lectura de las plantillas 
ingrese a la vista, en la parte inferior verá un  control para generar el 
listado en formato ODS o XLSX o PDF.  Cuando elija la plantilla y pulse en el 
botón será dirigido a la carpeta `generados` de la nube donde podrá ver el 
porcentaje de progreso en la generación y recargar hasta que termine el 
proceso.

En caso de que esté manejando su propia vista index debe tener un filtro 
como formulario y debe ser del siguiente estilo:

        <%= simple_form_for :filtro,
          { remote: true,
            url: sivel2_gen.envia_casos_filtro_path,
            method: "get" } do |f| %>
          ...
          <div class="row filtro-fila">
            <div class="col-sm-offset-0 col-sm-2 col-md-offset-1 col-md-1">
              Generar Plantilla
            </div>
            <div class="col-sm-offset-1 col-sm-4">
              <%= f.input :disgenera,
                collection: @plantillas,
                label: false,
                include_blank: false
              %>
            </div>
            <div class="col-sm-2">
              <%= link_to t('Generar'), 
                '#',
                class: 'btn', 
                target: '_blank', 
                onclick: 'heb412_gen_completa_generarp(this, \'#filtro_disgenera\',
                \'/casos/filtro\', \'casos/\')' %>

            </div>
            <div class="col-sm-3">
            </div>
          </div> <!-- row -->
        <% end %> 

Este método por omisión generará el `.ods` en la carpeta generados de la nube.

### 3.5 Ajuste presentación de campos

Puede ajustar la forma de presentar algunos campos bien en la función
`presenta` del modelo asociado al controlador o bien creando en el 
modelo funciones auxiliares. Pueden verse ejemplos de ambas posibilidades
en 
<https://gitlab.com/pasosdeJesus/msip/-/blob/master/lib/msip/concerns/models/persona.rb>
Por ejemplo una función `presenta(atr)` sobrecargada para presentar
sigla de un tipo de documento en lugar del nombre cuando el campo
solicitado es `tdoc`:

          def presenta(atr)
            case atr.to_s
            when 'nacionalde'
              nacionalde ? nacional.nombre : ''
            when 'tdoc'
              self.tdocumento.sigla if self.tdocumento
            else
              presenta_gen(atr)
            end
          end

Y la función auxiliar `presenta_fechanac`.

### 3.6 Generación de un listado en un .ods no estándar

Si requiere manejar varias hojas de una hoja de cálculo o cambios
mayores a la forma de llenar plantillas sugerimos sobrecargar en
el controlador la función `self.vista_listado` que será llamada
por la tarea que genera el ODS en la carpeta `generados` y que puede
bien alistar los registros por llenar automáticamente de forma
uniforme en una hoja de cálculo o bien generar directamente el ODS.
Puede ver un ejemplo en 
<https://gitlab.com/pasosdeJesus/si_jrscol/-/blob/master/app/controllers/cor1440_gen/proyectosfinancieros_controller.rb>


### 3.7 Configure una vista `show` que llenará un registro en una hoja de cálculo .ods

Es el mismo procedimiento que para la vista `index` pero las plantillas 
definidas se verán en la vista para la que se hayan definido en la parte 
inferior de la vista `show`.  

### 3.8 Nombre de las vistas en los formularios de definición 

En los formularios para definir una plantilla para un registro o para un 
listado, hay un campo `Vista` que presenta las diferentes llaves del 
diccionario retornado por `campos_plantillas`.

Esas llaves se podrían remplazar por nombres que se definan en 
`config/locale/es.yml` dentro de `heb412_gen/plantillahcm` para plantillas 
de listados, y dentro de `heb412_gen/plantillahcr` para plantillas de 
registros. Recordando que no es necesario definir en 
`heb412_gen/plantillahcr` llaves de plantillas que sean solo para listados 
(i.e con `solo_multiple: true` en diccionario retornado por 
`campos_plantillas`) y que en `heb412_gen/plantillahcm` no es necesario 
definir llaves para plantillas que sean sólo para un registro (i.e con 
con `solo_registro`).


### 3.9 Detalles de implementación de generación de campos que provienen 
    de subformularios

Por ejemplo de formularios de caracterización o de subformularios incrustados 
por un tipo de actividad. Ver 
<https://gitlab.com/pasosdeJesus/heb412_gen/-/blob/master/doc/campos_compuestos.md>


## 4. Documentación

La documentación técnica de las clases de este motor está disponible en
  <https://rubydoc.info/github/pasosdeJesus/heb412_gen/>

Aunque antes le podría resultar útil la documentación de msip disponible en:
<https://gitlab.com/pasosdeJesus/msip/blob/main/doc/README.md>

