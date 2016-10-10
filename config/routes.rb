# encoding: UTF-8

Heb412Gen::Engine.routes.draw do

  resources :docs, path_names: { new: 'nuevo', edit: 'edita' }#,  only: [:edit, :update, :new, :create, :destroy]

  get "docs/:id/impreso" => "docs#impreso", as: :impreso

#  namespace :admin do
#    ::Ability.tablasbasicas.each do |t|
#      if (t[0] == "Heb412Gen") 
#        c = t[1].pluralize
#        resources c.to_sym, 
#          path_names: { new: 'nueva', edit: 'edita' }
#      end
#    end
#  end


end
