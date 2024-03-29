# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorize_user, only: [:auto_login]

  # REGISTER
  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token(user_id: @user.id)
      render json: { user: @user, token: token }
    else
      render json: { error: @user.errors }, status: :bad_request
    end
  end

  # LOGGING IN
  def login
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      token = encode_token(user_id: @user.id)
      render json: { user: @user, token: token }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def auto_login
    render json: @user
  end

  private

    def user_params
      params.permit(:name, :email, :password)
    end
end
