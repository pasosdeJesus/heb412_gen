source 'https://rubygems.org'


# Resuelve problema con minitest y 5.2.0
gem "rails", '~> 6.0.0.rc1'

gem 'bootsnap'

gem 'webpacker'

# Use sqlite3 as the database for Active Record
gem 'pg'#, '~> 0.21'
# Use Puma as the app server
gem 'puma'

gem 'colorize'
# Use SCSS for stylesheets
gem 'sass'
gem 'sass-rails'

gem 'chosen-rails', git: 'https://github.com/vtamara/chosen-rails.git', branch: 'several-fixes'

gem 'redcarpet'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development


# Ambiente de CSS
gem "twitter-bootstrap-rails"
gem "bootstrap-datepicker-rails"
gem "font-awesome-rails"

# Facilita elegir colores en tema
gem 'pick-a-color-rails'
gem 'tiny-color-rails'

# Formularios simples 
gem "simple_form"

# Formularios anidados (algunos con ajax)
gem "cocoon", git: "https://github.com/vtamara/cocoon.git", branch: 'new_id_with_ajax'


# Autenticación y roles
gem "devise"
gem "devise-i18n"
gem "cancancan"
gem "bcrypt"

# Listados en páginas
gem "will_paginate"

# ICU con CLDR
gem 'twitter_cldr'

# Maneja adjuntos
gem "paperclip"#, "~> 4.1"

gem 'rubyzip', '>= 2.0'

# Genera ODT
gem 'odf-report', git: 'https://github.com/vtamara/odf-report.git', branch: 'rubyzip-1.3'

# Genera ODS
gem 'libxml-ruby'
gem 'rspreadsheet', git: 'https://github.com/vtamara/rspreadsheet.git', branch: 'rubyzip-1.3'


# Zonas horarias
gem "tzinfo"

# Motor de sistemas de información estilo Pasos de Jesús
gem 'sip', git: "https://github.com/pasosdeJesus/sip.git"
#gem 'sip', path: '../sip'

# Motor de formularios
gem 'mr519_gen', git: "https://github.com/pasosdeJesus/mr519_gen.git"
#gem 'mr519_gen', path: '../mr519_gen'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  #gem 'byebug', platform: :mri
 
end

group :test do

  gem 'simplecov'
  # Envia resultados de pruebas desde travis a codeclimate
end 

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
end

