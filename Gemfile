source 'https://rubygems.org'

git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

gemspec

gem 'babel-transpiler'

gem 'bootsnap'

gem 'cancancan' # Roles

gem 'coffee-rails', '~> 4.2'

gem 'cocoon', git: 'https://github.com/vtamara/cocoon.git', branch: 'new_id_with_ajax' # Formularios anidados (algunos con ajax)

gem 'devise' # Autenticación 

gem 'devise-i18n'

gem 'jbuilder', '~> 2.5'

gem 'jsbundling-rails'

gem 'kt-paperclip',                 # Anexos
  git: 'https://github.com/kreeti/kt-paperclip.git'

gem 'libxml-ruby'

gem 'nokogiri', '>=1.11.1'

gem 'odf-report' # Genera ODT

gem 'pg'

gem 'rails', '~> 7.0'
  #git: 'https://github.com/rails/rails.git', branch: '6-1-stable'

gem 'redcarpet'

gem 'rspreadsheet' # Genera ODS

gem 'rubyzip', '>= 2.0'

gem 'sassc-rails'

gem 'simple_form' # Formularios simples 

gem 'sprockets-rails'

gem 'stimulus-rails'

gem 'turbo-rails', '~> 1.0'

gem 'twitter_cldr' # ICU con CLDR

gem 'tzinfo' # Zonas horarias

gem 'will_paginate' # Listados en páginas

#####
# Motores que se sobrecargan vistas (deben ponerse en orden de apilamiento 
# lógico y no alfabetico como las gemas anteriores) para que sobrecarguen
# bien vistas

gem 'msip', # Motor generico
  git: 'https://github.com/pasosdeJesus/msip.git', branch: :main
  #path: '../msip'

gem 'mr519_gen', # Motor de gestion de formularios y encuestas
  git: 'https://github.com/pasosdeJesus/mr519_gen.git', branch: :msip
  #path: '../mr519_gen'


group :development, :test do
  gem 'debug', platform: :mri
 
  gem 'colorize'

  gem 'dotenv-rails'
end


group :test do
  gem 'capybara'

  gem 'cuprite'

  gem 'rails-controller-testing'

  gem 'simplecov', '<0.18'
end 


group :development do
  gem 'puma'

  gem 'spring'

  gem 'web-console'
end

