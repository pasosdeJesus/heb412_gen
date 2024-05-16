# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |_repo| 'https://github.com/#{repo}.git' }

gemspec

gem "babel-transpiler"

gem "bootsnap"

gem "cancancan" # Roles

gem "coffee-rails", "~> 4.2"

gem "cocoon", git: "https://github.com/vtamara/cocoon.git", branch: "new_id_with_ajax" # Formularios anidados (algunos con ajax)

gem "devise" # Autenticación

gem "devise-i18n"

gem "jbuilder", "~> 2.5"

gem "jsbundling-rails"

gem "kt-paperclip", # Anexos
  git: "https://github.com/kreeti/kt-paperclip.git"

gem "libxml-ruby"

gem "nokogiri", ">=1.11.1"

gem "odf-report" # Genera ODT

gem "pg"

gem "rails", "~> 7.2"
# git: 'https://github.com/rails/rails.git', branch: '6-1-stable'

gem "redcarpet"

gem "rspreadsheet" # Genera ODS

gem "rubyzip", ">= 2.0"

gem "sassc-rails"

gem "simple_form" # Formularios simples

gem "sprockets-rails"

gem "stimulus-rails"

gem "turbo-rails", "~> 1.0"

gem "twitter_cldr" # ICU con CLDR

gem "tzinfo" # Zonas horarias

gem "will_paginate" # Listados en páginas

#####
# Motores que se sobrecargan vistas (deben ponerse en orden de apilamiento
# lógico y no alfabetico como las gemas anteriores) para que sobrecarguen
# bien vistas

gem "msip", # Motor generico
  git: "https://gitlab.com/pasosdeJesus/msip.git", branch: 'v2.2'
  #path: '../msip-2.2'

gem "mr519_gen", # Motor de gestion de formularios y encuestas
  git: "https://gitlab.com/pasosdeJesus/mr519_gen.git", branch: 'v2.2'
  #path: '../mr519_gen-2.2'

group :development, :test do
  gem "brakeman"

  gem "bundler-audit"

  gem "code-scanning-rubocop"

  gem "colorize"

  gem "debug"

  gem "dotenv-rails"

  gem "rails-erd"

  gem "rubocop-minitest"

  gem "rubocop-rails"

  gem "rubocop-shopify"
end

group :test do
  gem "capybara"

  gem "cuprite"

  gem "rails-controller-testing"

  gem "simplecov"
end

group :development do
  gem "puma"

  gem "spring"

  gem "web-console"
end
