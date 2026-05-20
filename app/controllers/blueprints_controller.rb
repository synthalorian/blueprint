class BlueprintsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show, :share ]
  before_action :set_blueprint, only: [ :show, :edit, :update, :destroy, :duplicate ]
  before_action :authorize_owner!, only: [ :edit, :update, :destroy ]

  def index
    @blueprints = Blueprint.publicly.recent.page(params[:page]).per(12)
    @blueprints = @blueprints.where(user: current_user) if params[:mine] && user_signed_in?
  end

  def show
  end

  def share
    @blueprint = Blueprint.publicly.friendly.find(params[:id])
  end

  def new
    @blueprint = current_user.blueprints.build(
      yaml_content: Blueprint.new(name: "My Blueprint").send(:generate_yaml_content).strip
    )
  end

  def create
    @blueprint = current_user.blueprints.build(blueprint_params)
    if @blueprint.save
      redirect_to @blueprint, notice: "Blueprint created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @blueprint.update(blueprint_params)
      redirect_to @blueprint, notice: "Blueprint updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blueprint.destroy
    redirect_to blueprints_path, notice: "Blueprint deleted.", status: :see_other
  end

  def duplicate
    dup = @blueprint.dup
    dup.name = "#{@blueprint.name} (copy)"
    dup.slug = nil
    dup.user = current_user
    if dup.save
      redirect_to edit_blueprint_path(dup), notice: "Blueprint duplicated."
    else
      redirect_to blueprints_path, alert: "Could not duplicate blueprint."
    end
  end

  def search
    @blueprints = Blueprint.publicly
                          .where("name ILIKE ?", "%#{params[:q]}%")
                          .recent
                          .page(params[:page]).per(12)
    render :index
  end

  private

  def set_blueprint
    @blueprint = Blueprint.friendly.find(params[:id])
  end

  def authorize_owner!
    return if @blueprint.user == current_user
    redirect_to blueprints_path, alert: "Not authorized."
  end

  def blueprint_params
    params.require(:blueprint).permit(:name, :description, :yaml_content, :slug, :public)
  end
end
