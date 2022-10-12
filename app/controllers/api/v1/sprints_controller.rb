class Api::V1::SprintsController < ApplicationController
  before_action :set_sprint, only: [:show, :update, :destroy]

  # GET /api/v1/sprints
  def index
    @sprints = Sprint.all

    # render json: @sprints
    # json_response data: @sprints
    json_response({ message: "success", data: ActiveModelSerializers::SerializableResource.new(@sprints, each_serializer: SprintSerializer) })
  end

  # GET /api/v1/sprints/1
  def show
    data = ActiveModelSerializers::SerializableResource.new(@sprint, serializer: SprintSerializer)
    # data = @sprint
    json_response({ data: data, message: "success" })
  end

  # POST /api/v1/sprints
  def create
    @sprint = Sprint.new(sprint_params)

    if @sprint.save
      # render json: @sprint, status: :created, location: @sprint
      json_response({ data: ActiveModelSerializers::SerializableResource.new(@sprint, serializer: SprintSerializer), message: "success" }, :created)
    else
      raise ExceptionHandler::InvalidAction, @sprint.errors
      # json_response data: @sprint.errors, status: :unprocessable_entity
      # render json: @sprint.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/sprints/1
  def update
    # is_active = true
    value = sprint_params.except(:is_active)
    if @sprint.is_active.blank? && sprint_params[:is_active].present?
      value.merge({ is_active: true })
    end
    if @sprint.update(value)
      json_response({ data: ActiveModelSerializers::SerializableResource.new(@sprint, serializer: SprintSerializer), message: "success" }, :created)
      # render json: @sprint
    else
      raise ExceptionHandler::InvalidAction, @sprint.errors
      # json_response data: @sprint.errors, status: :unprocessable_entity
      # render json: @sprint.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/sprints/1
  def destroy
    @sprint.update({ is_active: false })
    json_response message: "success"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sprint
    @sprint = Sprint.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def sprint_params
    params.require(:data).permit(:title, :description, :start_date, :end_date, :is_active)
  end
end
