# frozen_string_literal: true

require "heb412_gen/concerns/controllers/camposplantillahcr_controller"

module Heb412Gen
  class CamposplantillahcrController < ApplicationController
    before_action :preparar_plantillahcr
    load_and_authorize_resource class: Heb412Gen::Campoplantillahcr

    include Heb412Gen::Concerns::Controllers::CamposplantillahcrController
  end
end
