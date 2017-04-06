# Motor Heb412 para manejar documentos y plantillas (tipo nube) en sistema de archivos
[![Esado Construcción](https://api.travis-ci.org/pasosdeJesus/heb412_gen.svg?branch=master)](https://travis-ci.org/pasosdeJesus/heb412_gen) [![Clima del Código](https://codeclimate.com/github/pasosdeJesus/heb412_gen/badges/gpa.svg)](https://codeclimate.com/github/pasosdeJesus/heb412_gen) [![Cobertura de Pruebas](https://codeclimate.com/github/pasosdeJesus/heb412_gen/badges/coverage.svg)](https://codeclimate.com/github/pasosdeJesus/heb412_gen) [![security](https://hakiri.io/github/pasosdeJesus/heb412_gen/master.svg)](https://hakiri.io/github/pasosdeJesus/heb412_gen/master) [![Dependencias](https://gemnasium.com/pasosdeJesus/heb412_gen.svg)](https://gemnasium.com/pasosdeJesus/heb412_gen) 

Este es un motor de Heb412 para manejar documentos y plantillas

Aplican practicamente las mismas instrucciones de otro motor genérico
basado en sip:
	https://github.com/pasosdeJesus/sal7711_gen

Para incluirlo en su aplicación rails:
1. Agregue las gemas necesarias en Gemfile:
```
	gem 'heb412_gen', git: 'https://github.com/pasosdeJesus/heb412_gen.git'
	gem 'font-awesome-rails'
	gem 'chosen-rails'
```

2. Cree un directorio que será la raíz del sistema de archivos y que
debe poder ser escrito por el usuario que ejecute la aplicación, e.g
```
	mkdir public/heb412/
```

3. Configure esa ruta en su aplicación en ```config/application.rb``` con
```
	config.x.heb412_ruta = Rails.root.join('public', 'heb412')
```

4. Agregue un menú o enlaces a los urls de , por ejemplo en
   ```app/views/layouts/application```:
```
	<%= menu_item "Nube", heb412_gen.sisini_path %>
```

5. Configure rutas en ```config/routes.rb```
```
	mount Heb412Gen::Engine => "/", as: 'heb412_gen'
```

6. Si hace falta agregue en su ```app/helpers/application_helper.rb```
```
	include FontAwesome::Rails::IconHelper 
```

7. Agregue en el archivo ```app/models/ability.rb``` la relación de campos 
   que un controlador puede dar a una plantilla. por ejemplo:

