class Api::V1::BlueprintsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_api_user!, except: [ :index, :show, :download_script, :download_yaml ]
  before_action :set_blueprint, only: [ :show, :update, :destroy, :download_script, :download_yaml ]

  def index
    blueprints = Blueprint.publicly.recent
    blueprints = blueprints.where(user: current_api_user) if current_api_user
    render json: blueprints, each_serializer: BlueprintSerializer
  end

  def show
    render json: @blueprint, serializer: BlueprintDetailSerializer
  end

  def create
    blueprint = current_api_user.blueprints.build(blueprint_params)
    if blueprint.save
      render json: blueprint, serializer: BlueprintDetailSerializer, status: :created
    else
      render json: { errors: blueprint.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize_blueprint_owner!
    if @blueprint.update(blueprint_params)
      render json: @blueprint, serializer: BlueprintDetailSerializer
    else
      render json: { errors: @blueprint.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_blueprint_owner!
    @blueprint.destroy
    head :no_content
  end

  def download_script
    return head :not_found unless @blueprint.public? || owned_by_current_user?
    send_data @blueprint.to_shell_script,
              filename: "#{@blueprint.slug}.sh",
              type: "application/x-shellscript"
  end

  def download_yaml
    return head :not_found unless @blueprint.public? || owned_by_current_user?
    send_data @blueprint.yaml_content,
              filename: "#{@blueprint.slug}.yml",
              type: "application/x-yaml"
  end

  private

  def set_blueprint
    @blueprint = Blueprint.friendly.find(params[:id])
  end

  def blueprint_params
    params.require(:blueprint).permit(:name, :description, :yaml_content, :slug, :public)
  end

  def authenticate_api_user!
    token = request.headers["Authorization"]&.remove("Bearer ")
    @current_api_user = User.find_by(authentication_token: token) if token
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_api_user
  end

  def current_api_user
    @current_api_user
  end

  def authorize_blueprint_owner!
    return if @blueprint.user == current_api_user
    render json: { error: "Forbidden" }, status: :forbidden
  end

  def owned_by_current_user?
    current_api_user && @blueprint.user == current_api_user
  end
end
