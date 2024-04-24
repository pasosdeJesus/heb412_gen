# frozen_string_literal: true

require "heb412_gen/concerns/controllers/carpetasexclusivas_controller"

module Heb412Gen
  class CarpetasexclusivasController < Msip::ModelosController
    before_action :set_carpetaexclusiva, only: [
      :edit,
      :update,
      :destroy,
      :show
    ]
    load_and_authorize_resource class: Heb412Gen::Carpetaexclusiva

    include Heb412Gen::Concerns::Controllers::CarpetasexclusivasController
  end
end
