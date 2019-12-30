# encoding: UTF-8

Rails.application.routes.draw do
  scope '/heb412' do 

    devise_scope :usuario do
      get 'sign_out' => 'devise/sessions#destroy'
    end
    devise_for :usuarios, :skip => [:registrations], module: :devise
    as :usuario do
      get 'usuarios/edit' => 'devise/registrations#edit', 
        :as => 'editar_registro_usuario'    
      put 'usuarios/:id' => 'devise/registrations#update', 
        :as => 'registro_usuario'            
    end
    resources :usuarios, path_names: { new: 'nuevo', edit: 'edita' } 

    root 'sip/hogar#index'

    namespace :admin do
      ab = ::Ability.new
      ab.tablasbasicas.each do |t|
        if (t[0] == "") 
          c = t[1].pluralize
          resources c.to_sym, 
            path_names: { new: 'nueva', edit: 'edita' }
        end
      end
    end
  end

  mount Heb412Gen::Engine, at: "/heb412", as: "heb412_gen"
  mount Mr519Gen::Engine, at: "/heb412", as: "mr519_gen"
  mount Sip::Engine, at: "/heb412", as: "sip"
end
