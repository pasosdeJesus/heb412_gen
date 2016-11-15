# encoding: UTF-8

Heb412Gen::Engine.routes.draw do

  #get "sisarch", to: "sisarch#index"
  get "sis/*ruta", to: "sisarch#index", as: :sisarch
  get "sis/arch", to: "sisarch#index", as: :sisini

  post "sis/nueva", to: "sisarch#nueva_carpeta", as: :nueva_carpeta
  post "sis/nuevo", to: "sisarch#nuevo_archivo", as: :nuevo_archivo

  resources :plantillahcm, path_names: { new: 'nueva', edit: 'edita' },  
    only: [:edit, :update, :new, :create, :destroy, :show]
  resources :docs, path_names: { new: 'nuevo', edit: 'edita' }#,  only: [:edit, :update, :new, :create, :destroy]

  get "docs/:id/impreso" => "docs#impreso", as: :impreso
  
  get "plantillahcm/:id/impreso" => "plantillahcm#impreso", 
    as: :plantillahcm_impresa


  namespace :admin do
    ab = ::Ability.new
    ab.tablasbasicas.each do |t|
      if (t[0] == "Heb412Gen") 
        c = t[1].pluralize
        resources c.to_sym, 
          path_names: { new: 'nueva', edit: 'edita' }
      end
    end
  end


end
