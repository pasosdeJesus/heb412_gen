# frozen_string_literal: true

require "heb412_gen/concerns/controllers/docs_controller"

module Heb412Gen
  class DocsController < ApplicationController
    load_and_authorize_resource class: Heb412Gen::Doc
    before_action :set_doc, only: [
      :edit,
      :update,
      :destroy,
      :show,
      :impreso,
    ]

    include Heb412Gen::Concerns::Controllers::DocsController
  end
end
