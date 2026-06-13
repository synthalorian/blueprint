class Api::V1::BlueprintsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_api_user!, except: [ :index, :show, :download_script, :download_yaml ]
  before_action :set_blueprint, only: [ :show, :update, :destroy, :download_script, :download_yaml ]

  def index
    blueprints = Blueprint.publicly.includes(:user).recent
    blueprints = blueprints.where(user: current_api_user) if current_api_user
    render json: blueprints.map { |bp| BlueprintSerializer.new(bp).as_json }
  end

  def show
    render json: BlueprintDetailSerializer.new(@blueprint).as_json
  end

  def create
    blueprint = current_api_user.blueprints.build(blueprint_params)
    if blueprint.save
      render json: BlueprintDetailSerializer.new(blueprint).as_json, status: :created
    else
      render json: { errors: blueprint.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize_blueprint_owner!
    return if performed?
    if @blueprint.update(blueprint_params)
      render json: BlueprintDetailSerializer.new(@blueprint).as_json
    else
      render json: { errors: @blueprint.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_blueprint_owner!
    return if performed?
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
    @blueprint = Blueprint.includes(:user, :packages, :dotfiles, :environment_variables, :services).friendly.find(params[:id])
  end

  def blueprint_params
    params.require(:blueprint).permit(:name, :description, :yaml_content, :slug, :public)
  end

  def authenticate_api_user!
    token = request.headers["Authorization"]&.remove("Bearer ")
    @current_api_user = User.find_by(authentication_token: token) if token
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_api_user
    nil
  end

  def current_api_user
    @current_api_user
  end

  def authorize_blueprint_owner!
    return if @blueprint.user == current_api_user
    render json: { error: "Forbidden" }, status: :forbidden
    nil
  end

  def owned_by_current_user?
    (current_api_user && @blueprint.user == current_api_user) || (current_user && @blueprint.user == current_user)
  end
end
