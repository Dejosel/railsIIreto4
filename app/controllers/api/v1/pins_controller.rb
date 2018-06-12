class Api::V1::PinsController < ApplicationController
  before_action :authenticate_user
  skip_before_action :verify_authenticity_token

  def index
    render json: Pin.all.order('created_at DESC')
  end

  def create
    pin = Pin.new(pin_params)
    if pin.save
      render json: pin, status: 201
    else
      render json: { errors: pin.errors }, status: 422
    end
  end

  def authenticate_user
    email = request.headers['HTTP_X_USER_EMAIL']
    api_token = request.headers['HTTP_X_API_TOKEN']
    if @current_user = User.find_by(email: email)
      if @current_user.api_token == api_token
        puts "Authorized User"
      else
        render json: { errors: {password:"must be a valid password"}}, status: 401
      end
    else
     render json: { errors: {email:"must be a valid email"}}, status: 401
    end
  end

  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end
end