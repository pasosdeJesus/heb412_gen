source 'https://rubygems.org'

git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

gemspec


gem 'bcrypt'

gem 'bootsnap'

gem 'bootstrap-datepicker-rails'

gem 'cancancan' # Roles

gem 'coffee-rails', '~> 4.2'

gem 'cocoon', git: 'https://github.com/vtamara/cocoon.git', branch: 'new_id_with_ajax' # Formularios anidados (algunos con ajax)

gem 'devise' # Autenticación 

gem 'devise-i18n'

gem 'jbuilder', '~> 2.5'

gem 'jquery-ui-rails' 

gem 'libxml-ruby'

gem 'odf-report' # Genera ODT

gem 'paperclip' # Maneja adjuntos

gem 'pg'

gem 'pick-a-color-rails'# Facilita elegir colores en tema

gem 'puma'

gem 'rails', '~> 6.0.0.rc1'

gem 'redcarpet'

gem 'rspreadsheet' # Genera ODS

gem 'rubyzip', '>= 2.0'

gem 'sassc-rails'

gem 'simple_form' # Formularios simples 

gem 'tiny-color-rails'

gem 'twitter_cldr' # ICU con CLDR

gem 'tzinfo' # Zonas horarias

gem 'webpacker'

gem 'will_paginate' # Listados en páginas

#####
# Motores que se sobrecargan vistas (deben ponerse en orden de apilamiento 
# lógico y no alfabetico como las gemas anteriores) para que sobrecarguen
# bien vistas

gem 'sip', # Motor generico
#  git: 'https://github.com/pasosdeJesus/sip.git', branch: :bs4
   path: '../sip'

gem 'mr519_gen', # Motor de gestion de formularios y encuestas
#  git: 'https://github.com/pasosdeJesus/mr519_gen.git', branch: :bs4
   path: '../mr519_gen'


group :development, :test do

  #gem 'byebug', platform: :mri
 
  gem 'colorize'

end


group :test do

  gem 'simplecov'

end 


group :development do
  
  gem 'spring'

  gem 'web-console'
end

