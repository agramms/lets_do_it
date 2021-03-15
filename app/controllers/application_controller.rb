# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authorize_user

  JWT_SECRET = Rails.application.credentials.secret_key_base.freeze

  def authorize_user
    auth_header = request.headers['Authorization']
    token = auth_header.split.last
    decoded_token = decode_token(token)
    user_id = decoded_token.first['user_id']
    @user = User.find_by(id: user_id)

    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end

  def encode_token(payload)
    JWT.encode(payload, jwk.keypair, 'RS512', jwk_private.export)
  end

  def logged_in?
    @user.present?
  end

  def decode_token(token)
    JWT.decode(token, nil, true, algorithms: ['RS512'], jwks: jwk_loader).first
  rescue JWT::DecodeError
    nil
  end

  private

    def jwk_private
      return @jwk_private if defined?(@jwk_private)

      priv_key = OpenSSL::PKey::RSA.new(File.read(Rails.root.join('certs', 'private.key')))
      @jwk_private = JWT::JWK.new(priv_key)
    end

    def jwk_loader
      return @jwk_loader if defined?(@jwk_loader)

      pub_key = OpenSSL::PKey::RSA.new File.read Rails.root.join('certs', 'public.key')
      jwk = JWT::JWK.new(pub_key)

      @jwk_loader = lambda options do
        @cached_keys = nil if options[:invalidate] # need to reload the keys
        @cached_keys ||= { keys: [jwk.export] }
      end
    end
end
