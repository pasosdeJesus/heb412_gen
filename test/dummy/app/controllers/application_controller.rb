# frozen_string_literal: true

class ApplicationController < Msip::ApplicationController
  protect_from_forgery with: :exception
end
