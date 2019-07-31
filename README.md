# Motor Heb412 para manejar nube de documentos y plantillas por llenar (hojas de cálculo .ods y documentos .odt)
[![Esado Construcción](https://api.travis-ci.org/pasosdeJesus/heb412_gen.svg?branch=master)](https://travis-ci.org/pasosdeJesus/heb412_gen) [![Clima del Código](https://codeclimate.com/github/pasosdeJesus/heb412_gen/badges/gpa.svg)](https://codeclimate.com/github/pasosdeJesus/heb412_gen) [![Cobertura de Pruebas](https://codeclimate.com/github/pasosdeJesus/heb412_gen/badges/coverage.svg)](https://codeclimate.com/github/pasosdeJesus/heb412_gen) [![security](https://hakiri.io/github/pasosdeJesus/heb412_gen/master.svg)](https://hakiri.io/github/pasosdeJesus/heb412_gen/master) [![Dependencias](https://gemnasium.com/pasosdeJesus/heb412_gen.svg)](https://gemnasium.com/pasosdeJesus/heb412_gen) 

![Logo de heb412_gen](https://raw.githubusercontent.com/pasosdeJesus/heb412_gen/master/test/dummy/app/assets/images/logo.jpg)

Este es el motor principal de la aplicación (https://github.com/pasosdeJesus/heb412)[Heb412] 
que maneja una nube de documentos y plantillas ods y odt

Aplican practicamente las mismas instrucciones de otros motores genérico
basados en sip, ver por ejemplo:
	https://github.com/pasosdeJesus/sal7711_gen

Para incluirlo en su aplicación rails que ya usa sip:
# 1. Configure la aplicación para usar este motor:9¿
```
	gem 'heb412_gen', git: 'https://github.com/pasosdeJesus/heb412_gen.git'
	gem 'font-awesome-rails'
	gem 'chosen-rails'
	gem 'rspreadsheet'
	gem 'redcarpet'
```

# 2. Incluya el motor javascript en su app/assets/javascript/application.js
   por ejemplo después de ```//= require sip/motor``` agregue:
```
//= require heb412_gen/motor
```
   y despúes de ```sip_prepara_eventos_comunes...``` agregue:
```
heb412_gen_prepara_eventos_comunes(root);
```

# 3. Configure su aplicación para proveer Nube mediante ```heb412_gen```:

## 3.1 Cree un directorio que será la raíz del sistema de archivos y que
debe poder ser escrito por el usuario que ejecute la aplicación, e.g
```
	mkdir public/heb412/
```

## 3.2 Configure esa ruta en su aplicación en ```config/application.rb``` con
```
	config.x.heb412_ruta = Rails.root.join('public', 'heb412')
```

## 3.3 Agregue un menú o enlaces a los urls de la nube por ejemplo en
   ```app/views/layouts/application```:
```
	<%= menu_item "Nube", heb412_gen.sisini_path %>
```

## 3.4 Configure rutas en ```config/routes.rb```
```
	mount Heb412Gen::Engine, at: '/', as: 'heb412_gen'
```

## 3.5 Si hace falta agregue en su ```app/helpers/application_helper.rb```
```
	include FontAwesome::Rails::IconHelper 
```
Notará que hace falta si al correr el servidor de prueba recibe un error como 
```undefined method `fa_icon' for #<#<Class:0x0009d035bb1610>:0x0009cfe0b333a0>```

# 4. Configure su aplicación para utilizar los llenadores de plantillas

Hay 3 tipos de llenadores de plantillas:
- Para llenar una plantilla ODS con datos de un listado (vista index),
  que se supone puede demorarse en generar una conjunto grande de datos

- Para llenar una plantilla ODS con datos de un resumen (vista show), 
  que suponemos se genera rápido.

- Para llenar una plantilla ODT con datos de un resumen (vista show),
  que suponemos se genera rápido.


## 4.1 Agregue en el archivo ```app/models/ability.rb``` la relación de campos 
   que un controlador puede dar a una plantilla en la función
   ```campos_plantillas```. Por ejemplo el modelo Actividad con controlador 
    Cor1440Gen::ActividadesControlador podría publicar disponibilidad
    de campos id, fecha y otros así:

```
    CAMPOS_PLANTILLAS_PROPIAS = {
      'Actividad' => { 
        campos: [
          'id', 'fecha', 'oficina', 'responsable', 'nombre', 
          'areas', 'subareas', 'convenios_financieros', 
          'actividades_de_convenio', 'objetivo', 'poblacion'
        ],
        controlador: 'Cor1440Gen::ActividadesController'
      }
    }

    def campos_plantillas 
      Heb412Gen::Ability::CAMPOS_PLANTILLAS_PROPIAS.
        clone.merge(CAMPOS_PLANTILLAS_PROPIAS)
    end
```

## 4.2 En `app/models/ability.rb` de permiso a un usuario (digamos administrador) 
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

## 4.3 Cree una entrada en el menú que permite acceder a la funcionalidad
    de definir una plantilla. Por ejemplo en 
    ```app/views/layouts/application.html.erb```
    algo  como:
```
 <% if can? :manage, Heb412Gen::Plantillahcm %>
   <%= menu_item "Nueva plantilla para listado en hoja de calculo",   
       heb412_gen.new_plantillahcm_path %>
 <% end %>
```

4.4 Para genrar un listado, la vista ```index``` del controlador que 
    llenará plantillas debe tener un 
    filtro como formulario.  Para eso haga el controlador descendiente
    de Heb412Gen::ModelosController (en lugar de Sip::ModelosController)
    cuya vista index ya lo incluye.
    En caso de que esté manejando su propia vista index debe ser del estilo:

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
Este método por omisión generará el ODS en la carpeta generados de la nube.

4.5 La vista show se comportará de manera análoga pero generará en línea 
    bien el .ods o bien el .odt

4.6 Puede ajustar la forma de presentar algunos campos bien en la función
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
    
4.7 Si requiere manejar varias hojas de una hoja de cálculo o cambios
    mayores a la forma de llenar plantillas sugerimos sobrecargar en
    el controlador la función self.vista_listado que será llamada
    por la tarea que genera el ODS en la carpeta generados y que puede
    bien alistar los registros por llenar automáticamente de forma
    uniforme en una hoja de cálculo o generar directamente el ODS.  
    Puede ver un ejemplo en 
      https://github.com/pasosdeJesus/cor1440_cinep/blob/master/app/controllers/cor1440_gen/proyectosfinancieros_controller.rb


