# frozen_string_literal: true

class StatusController < ApplicationController
  skip_before_action :authorize_user

  def healthy
    render json: { success: true }
  end
end
