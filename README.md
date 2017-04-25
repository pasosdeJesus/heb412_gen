# Motor Heb412 para manejar nube de documentos y plantillas por llenar (hojas de cálculo .ods y documentos .odt)
[![Esado Construcción](https://api.travis-ci.org/pasosdeJesus/heb412_gen.svg?branch=master)](https://travis-ci.org/pasosdeJesus/heb412_gen) [![Clima del Código](https://codeclimate.com/github/pasosdeJesus/heb412_gen/badges/gpa.svg)](https://codeclimate.com/github/pasosdeJesus/heb412_gen) [![Cobertura de Pruebas](https://codeclimate.com/github/pasosdeJesus/heb412_gen/badges/coverage.svg)](https://codeclimate.com/github/pasosdeJesus/heb412_gen) [![security](https://hakiri.io/github/pasosdeJesus/heb412_gen/master.svg)](https://hakiri.io/github/pasosdeJesus/heb412_gen/master) [![Dependencias](https://gemnasium.com/pasosdeJesus/heb412_gen.svg)](https://gemnasium.com/pasosdeJesus/heb412_gen) 

Este es un motor de Heb412 para manejar nube de documentos y plantillas ods y odt

Aplican practicamente las mismas instrucciones de otros motores genérico
basados en sip, ver por ejemeplo:
	https://github.com/pasosdeJesus/sal7711_gen

Para incluirlo en su aplicación rails que ya usa sip:
1. Agregue las gemas necesarias en Gemfile:
```
	gem 'heb412_gen', git: 'https://github.com/pasosdeJesus/heb412_gen.git'
	gem 'font-awesome-rails'
	gem 'chosen-rails'
	gem 'rspreadsheet'
```

2. Incluya el motor javascript en su app/assets/javascript/application.js
   por ejemplo después de ```//= require sip/motor``` agregue:
```
//= require heb412_gen/motor
```
   y despúes de ```sip_prepara_eventos_comunes...``` agregue:
```
heb412_gen_prepara_eventos_comunes(root);
```

3. Configure su aplicación para proveer Nube mediante ```heb412_gen```:

3.1 Cree un directorio que será la raíz del sistema de archivos y que
debe poder ser escrito por el usuario que ejecute la aplicación, e.g
```
	mkdir public/heb412/
```

3.2 Configure esa ruta en su aplicación en ```config/application.rb``` con
```
	config.x.heb412_ruta = Rails.root.join('public', 'heb412')
```

3.3 Agregue un menú o enlaces a los urls de la nube por ejemplo en
   ```app/views/layouts/application```:
```
	<%= menu_item "Nube", heb412_gen.sisini_path %>
```

3.4 Configure rutas en ```config/routes.rb```
```
	mount Heb412Gen::Engine, at: '/', as: 'heb412_gen'
```

3.5 Si hace falta agregue en su ```app/helpers/application_helper.rb```
```
	include FontAwesome::Rails::IconHelper 
```

4. Configure su aplicación para utilizar los llenadores de plantillas

Se planean 3 tipos de llenadores de plantillas:
- Para llenar una plantilla ODS con datos como los de un index
- Para llenar una plantilla ODS con datos como los de un show
- Para llenar una plantilla ODT con datos como los de un show

En el momento está completa la implementación del primero

4.1 Agregue en el archivo ```app/models/ability.rb``` la relación de campos 
   que un controlador puede dar a una plantilla en la función
   ```campos_plantillas```. Por ejemplo el modelo Actividad con controlador 
    Cor1440Gen::ActividadesControlador podría publicar disponibilidad
    de campos id, fecha y otros así:

```
    CAMPOS_PLANTILLAS_PROPIAS = {
      'Actividad' => { 
        campos: [
          'id', 'fecha', 'oficina', 'responsable', 'nombre', 
          'tipos_de_actividad', 'areas', 'subareas', 'convenios_financieros',
          'objetivo', 'poblacion', 'anexos'
        ],
        controlador: 'Cor1440Gen::ActividadesController'
      }
    }

    def campos_plantillas 
      Heb412Gen::Ability::CAMPOS_PLANTILLAS_PROPIAS.
        clone.merge(CAMPOS_PLANTILLAS_PROPIAS)
    end
```

4.2 De permiso a un usuario para manejar plantillas:
	can :manage, Heb412Gen::Doc

4.3 Cree una entrada en el menú que permite acceder a la funcionalidad
    de definir una plantilla

4.4 La vista index del controlador que generará plantillas debe tener un 
    filtro como formulario.  Agregue a este filtro un selector para las 
    posibles plantillas y un botón para generarlas por ejemplo:
 
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

4.5 El controlador en su método index debe filtrar los datos de acuerdo
    a los parámetros y responder al formato ods utilizando el parametro
    idplantilla que contendrá la identificación de la plantilla por llenar
    y generar.  
    Debe asegurar que los datos resultantes que pasa a la función
    Heb412Gen::PlantillahcmController.llena_plantilla_multiple_fd
    se pueden recorrer con each y que cada registro (objeto) tendra los 
    campos declarados en app/models/ability.rb.
    Por ejemplo si los campos declarados en app/models/ability 
    coinciden con los campos del modelo Activdad:

	@actividades = Actividad.all
	# se filtra de acuerdo a param y se eligen con nombres
	...
	respond_to do |format|
		format.html { # Lo que necesita 
...
		}
		format.json { # API
		}
              format.ods { # Se solicitó llenar plantilla
                if params[:idplantilla].nil? 
                  head :no_content 
                elsif params[:idplantilla].to_i <= 0
                  head :no_content 
                elsif Heb412Gen::Plantillahcm.where(
                    id: params[:idplantilla].to_i).take.nil?
                  head :no_content 
                else
                  pl = Heb412Gen::Plantillahcm.find(
                    params[:idplantilla].to_i)
                  n = Heb412Gen::PlantillahcmController.
                    llena_plantilla_multiple_fd(pl, @actividades)
                  send_file n, x_sendfile: true
                end
              }


  La sugerencia es hacer una vista materializada que incluya la información que 
  se requiere y que comience con los datos filtrados por index.

