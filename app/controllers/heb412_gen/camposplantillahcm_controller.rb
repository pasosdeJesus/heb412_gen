# frozen_string_literal: true

require "heb412_gen/concerns/controllers/camposplantillahcm_controller"

module Heb412Gen
  class CamposplantillahcmController < ApplicationController
    before_action :preparar_plantillahcm
    load_and_authorize_resource class: Heb412Gen::Campoplantillahcm

    include Heb412Gen::Concerns::Controllers::CamposplantillahcmController
  end
end
