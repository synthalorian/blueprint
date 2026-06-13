require "securerandom"

class Api::V1::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      user.update!(authentication_token: SecureRandom.hex(32)) unless user.authentication_token.present?
      render json: { token: user.authentication_token, email: user.email }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def destroy
    token = request.headers["Authorization"]&.remove("Bearer ")
    user = User.find_by(authentication_token: token)
    user&.update!(authentication_token: nil)
    head :no_content
  end
end
