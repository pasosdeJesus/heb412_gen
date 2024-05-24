# frozen_string_literal: true

Heb412Gen::Engine.routes.draw do

  resources :campoplantillahcm, only: [], param: :index do
    member do
      delete '(:id)', to: "camposplantillahcm#destroy", as: "eliminar"
      post '/' => "camposplantillahcm#create", as: "crear"
    end
  end

  resources :carpetasexclusivas,
    path_names: { new: "nuevo", edit: "edita" }

  resources :docs,
    path_names: { new: "nuevo", edit: "edita" } 
  # ,  only: [:edit, :update, :new, :create, :destroy]

  get "docs/:id/impreso" => "docs#impreso", as: :impreso
  get "sis/*ruta", to: "sisarch#index", as: :sisarch
  get "sis/arch", to: "sisarch#index", as: :sisini

  post "sis/nueva", to: "sisarch#nueva_carpeta", as: :nueva_carpeta
  post "sis/nuevo", to: "sisarch#nuevo_archivo", as: :nuevo_archivo
  post "sis/actleeme", to: "sisarch#actleeme", as: :actleeme
  post "sis/eliminararc", to: "sisarch#eliminar_archivo", as: :eliminar_archivo
  post "sis/eliminardir", to: "sisarch#eliminar_directorio", as: :eliminar_directorio

  get "plantillahcm/pintacampos" => "plantillahcm#pintacampos",
    as: :plantillahcm_pintacampos

  get "plantillashcm" => "plantillahcm#index",
    as: :plantillashcm

  get "plantillashcm/importadatos" => "plantillahcm#importadatos",
    as: :plantillashcm_importadatos
  post "plantillashcm/importadatos" => "plantillahcm#importadatos",
    as: :plantillashcm_envia_importadatos

  get "plantillahcr/pintacampos" => "plantillahcr#pintacampos",
    as: :plantillahcr_pintacampos

  get "plantillashcr" => "plantillahcr#index",
    as: :plantillashcr

  post "plantillahcm" => "plantillahcm#create", as: :crea_plantillahcm

  post "plantillahcr" => "plantillahcr#create", as: :crea_plantillahcr

  resources :plantillahcm, path_names: { new: "nueva", edit: "edita" }

  resources :plantillahcr, path_names: { new: "nueva", edit: "edita" }

  resources :plantillasdoc, path_names: { new: "nueva", edit: "edita" }

  get "plantillahcm/:id/impreso" => "plantillahcm#impreso",
    as: :plantillahcm_impresa

  get "plantillahcr/:id/impreso" => "plantillahcr#impreso",
    as: :plantillahcr_impresa

  get "/orgsociales/:id/fichaimp" => "/msip/orgsociales#fichaimp",
    as: :orgsocial_fichaimp

  get "/orgsociales/:id/fichapdf" => "/msip/orgsociales#fichapdf",
    as: :orgsocial_fichapdf

  get "/personas/:id/fichaimp" => "/msip/personas#fichaimp",
    as: :persona_fichaimp

  get "/personas/:id/fichapdf" => "/msip/personas#fichapdf",
    as: :persona_fichapdf

  get "/usuarios/:id/fichaimp" => "/usuarios#fichaimp",
    as: :usuario_fichaimp

  get "/usuarios/:id/fichapdf" => "/usuarios#fichapdf",
    as: :usuario_fichapdf

  namespace :admin do
    ab = Ability.new
    ab.tablasbasicas.each do |t|
      next unless t[0] == "Heb412Gen"

      c = t[1].pluralize
      resources c.to_sym,
        path_names: { new: "nueva", edit: "edita" }
    end
  end
end
