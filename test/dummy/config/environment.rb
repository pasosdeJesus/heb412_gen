# Carga aplicación Rails
require_relative 'application'

ActiveRecord::Base.pluralize_table_names=false

# Inicializa aplicación Rails
Rails.application.initialize!
