require "heb412_gen/concerns/controllers/orgsociales_controller"

module Msip
  class OrgsocialesController < Heb412Gen::ModelosController

    before_action :set_orgsocial, only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource class: Msip::Orgsocial

    include Heb412Gen::Concerns::Controllers::OrgsocialesController
  end
end
