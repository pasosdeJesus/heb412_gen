# Motor heb412_gen para manejar nube de documentos y plantillas (hojas de cálculo .ods y documentos .odt)
[![Esado Construcción](https://api.travis-ci.org/pasosdeJesus/heb412_gen.svg?branch=master)](https://travis-ci.org/pasosdeJesus/heb412_gen) [![Clima del Código](https://codeclimate.com/github/pasosdeJesus/heb412_gen/badges/gpa.svg)](https://codeclimate.com/github/pasosdeJesus/heb412_gen) [![Cobertura de Pruebas](https://codeclimate.com/github/pasosdeJesus/heb412_gen/badges/coverage.svg)](https://codeclimate.com/github/pasosdeJesus/heb412_gen) [![security](https://hakiri.io/github/pasosdeJesus/heb412_gen/master.svg)](https://hakiri.io/github/pasosdeJesus/heb412_gen/master) [![Dependencias](https://gemnasium.com/pasosdeJesus/heb412_gen.svg)](https://gemnasium.com/pasosdeJesus/heb412_gen) 

![Logo de heb412_gen](https://raw.githubusercontent.com/pasosdeJesus/heb412_gen/master/test/dummy/app/assets/images/logo.jpg)

Este es el motor principal de la aplicación (https://github.com/pasosdeJesus/heb412)[Heb412] 
que maneja una nube de documentos y plantillas ods y odt

Aplican practicamente las mismas instrucciones de otros motores genérico
basados en sip, ver por ejemplo:
	https://github.com/pasosdeJesus/sal7711_gen

Las funcionalidades que provee al momento de este escrito son:

1. Nube de documentos
2. Exportación de información
   1. Expotación de un sólo registro a una plantilla .ods
   2. Exportación de un sólo registro a una plantilla .odt
   3. Exportación de un conjunto de registros a una plantilla .ods (estilo listado)
3. Importación de información
   1. Importación de un conjunto de registros desde un listado .ods 

La exportación e importación requieren la previa configuración de la nube.

## 1. Configure gemas, javascript y base de datos

Este motor opera sobre [sip](https://github.com/pasosdeJesus/sip). 

En su Gemfile asegure tener:

```	
	gem 'rspreadsheet'
	gem 'redcarpet'

        gem 'sip', 
          git: 'https://github.com/pasosdeJesus/heb412_gen.git'
	gem 'heb412_gen', 
	  git: 'https://github.com/pasosdeJesus/heb412_gen.git'
```


Incluya el motor javascript en su `app/assets/javascript/application.js` 
   por ejemplo después de `//= require sip/motor` agregue:
```
//= require heb412_gen/motor
```
   y despúes de `sip_prepara_eventos_comunes...` agregue:
```
heb412_gen_prepara_eventos_comunes(root);
```

Ejecute migraciones que agregarán las tablas necesarias
```
bin/rails db:migrate
```

## 2. Configure su aplicación para proveer Nube

### 2.1 Cree un directorio que será la raíz del sistema de archivos y que
debe poder ser escrito por el usuario que ejecute la aplicación, e.g
```
	mkdir public/heb412/
```

### 2.2 Configure esa ruta en su aplicación en ```config/application.rb``` con
```
	config.x.heb412_ruta = Rails.root.join('public', 'heb412')
```

### 2.3 Agregue un menú o enlaces a los urls de la nube por ejemplo en
   ```app/views/layouts/application```:
```
	<%= menu_item "Nube", heb412_gen.sisini_path %>
```

### 2.4 Configure rutas en ```config/routes.rb```
```
	mount Heb412Gen::Engine, at: '/', as: 'heb412_gen'
```

## 3. Configure su aplicación para utilizar llenadores de plantillas

Hay 3 tipos de llenadores de plantillas:
- Para llenar una plantilla ODS con datos de un listado (vista index),
  que se supone puede demorarse en generar una conjunto grande de datos

- Para llenar una plantilla ODS con datos de un resumen (vista show), 
  que suponemos se genera rápido.

- Para llenar una plantilla ODT con datos de un resumen (vista show),
  que suponemos se genera rápido.

El más desarrollado es el primero, que explicamos a continuación.

### 3.1 Relacione disponibilidad de campos exportables/importables

Agregue en el archivo `app/models/ability.rb` la relación de campos 
   que un controlador puede dar a una plantilla en la función
   ```campos_plantillas```. Por ejemplo el modelo `Actividad` con controlador 
    `Cor1440Gen::ActividadesController` que se presenta en la ruta `/actividades`
    podría publicar disponibilidad de campos `id`, `fecha` y otros así:

```
    CAMPOS_PLANTILLAS_PROPIAS = {
      'Actividad' => { 
        campos: [
          'id', 'fecha', 'oficina', 'responsable', 'nombre', 
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
```
Vea un ejemplo más completo en <https://github.com/pasosdeJesus/cor1440_cinep/blob/master/app/models/ability.rb>

### 3.2 Permisos para gestionar y/o para llenar plantillas

En `app/models/ability.rb` de permiso a un usuario (digamos administrador) 
  para manejar plantillas:
```
	can :manage, Heb412Gen::Doc
	can :manage, Heb412Gen::Plantillahcm
	can :manage, Heb412Gen::Plantillahcr
	can :manage, Heb412Gen::Plantilladoc
```
  y a usuarios que necesiten generarlas por lo menos de lectura
```
	can :read, Heb412Gen::Doc
	can :manage, Heb412Gen::Plantillahcm
	can :manage, Heb412Gen::Plantillahcr
	can :manage, Heb412Gen::Plantilladoc
```

### 3.3 Menú para gestionar plantillas

Cree una entrada en el menú que permite acceder a la funcionalidad
    de definir una plantilla. Por ejemplo en 
    ```app/views/layouts/application.html.erb```
    algo  como:
```
 <% if can? :manage, Heb412Gen::Plantillahcm %>
   <%= menu_item "Nueva plantilla para listado en hoja de calculo",   
       heb412_gen.new_plantillahcm_path %>
 <% end %>
```

### 3.4 Configure una vista `index` que llenará un listado .ods

Será simple cuando inicialmente el controlador sea descendiente de `Sip::ModelosController`
y emplee la función por omisión `index` y la respectiva vista automática pues en tal caso basta que
haga el controlador descendiente de `Heb412Gen::ModelosController` y que añada
la función `vistas_manejadas` con un listado de las vistas que el controlador maneja
de entre las referenciadas por la función `campos_plantillas` de `ability.rb`.  

Por ejemplo:
```
...
  class ActoressocialesController < Heb412Gen::ModelosController
...
    def vistas_manejadas
      ['Actorsocial']
    end
...
```

Después debe inicar la aplicación y un administrador debe gestionar una o
varias plantillas en listado  `.ods` para la vista en cuestión.

Después de esto, cuando un usuario con permiso de lectura de las plantillas ingrese 
a la vista, en la parte inferior verá un  control para generar el listado en formato ODS o XLSX.  
Cuando elija la plantilla y pulse en el botón será dirigido a la carpeta `generados` 
de la nube donde podrá ver el porcentaje de progreso en la generación y 
recargar hasta que termine el proceso.

En caso de que esté manejando su propia vista index debe tener un filtro como formulario 
y debe ser del siguiente estilo:

 ```
<%= simple_form_for :filtro,
  { remote: true,
    url: sivel2_gen.envia_casos_filtro_path,
    method: "get" } do |f| 
%>
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
```
Este método por omisión generará el `.ods` en la carpeta generados de la nube.

### 3.5 Ajuste presentación de campos

Puede ajustar la forma de presentar algunos campos bien en la función
    `presenta` del modelo asociado al controlador o bien creando en el 
    modelo funciones auxiliares. Pueden verse ejemplos de ambas posibilidades
    en https://github.com/pasosdeJesus/sip/blob/master/lib/sip/concerns/models/persona.rb  
    Por ejemplo una función `presenta(atr)` sobrecargada para presentar
    sigla de un tipo de documento en lugar del nombre cuando el campo
    solicitado es `tdoc`:
```
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
```
Y la función auxiliar `presenta_fechanac`.
    
### 3.6 Generación de un listado en un .ods no estándar

Si requiere manejar varias hojas de una hoja de cálculo o cambios
    mayores a la forma de llenar plantillas sugerimos sobrecargar en
    el controlador la función self.vista_listado que será llamada
    por la tarea que genera el ODS en la carpeta generados y que puede
    bien alistar los registros por llenar automáticamente de forma
    uniforme en una hoja de cálculo o generar directamente el ODS.  
    Puede ver un ejemplo en 
      https://github.com/pasosdeJesus/cor1440_cinep/blob/master/app/controllers/cor1440_gen/proyectosfinancieros_controller.rb

## 4. Configure su aplicación para importar información

