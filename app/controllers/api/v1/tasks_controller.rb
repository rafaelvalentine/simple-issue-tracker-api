class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  # GET  /api/v1/tasks
  def index
    @tasks = Task.all

    # render json: @tasks
    # ActiveModelSerializers::SerializableResource.new(@tasks, each_serializer: TaskSerializer)
    json_response({ message: "success", data: ActiveModelSerializers::SerializableResource.new(@tasks, each_serializer: TaskSerializer) })
  end

  # GET  /api/v1/tasks/1
  def show

    # render json: @task
    json_response({ message: "success", data: ActiveModelSerializers::SerializableResource.new(@task, serializer: TaskSerializer) })
  end

  # POST  /api/v1/tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      # render json: @task, status: :created, location: @task
      json_response({ message: "success", data: ActiveModelSerializers::SerializableResource.new(@task, serializer: TaskSerializer) })
    else
      # render json: @task.errors, status: :unprocessable_entity
      raise ExceptionHandler::InvalidAction, @task.errors
    end
  end

  # PATCH/PUT  /api/v1/tasks/1
  def update
    if @task.update(task_params.except(:is_active))
      # render json: @task
      json_response({ message: "success", data: ActiveModelSerializers::SerializableResource.new(@task, serializer: TaskSerializer) })
    else
      # render json: @task.errors, status: :unprocessable_entity
      raise ExceptionHandler::InvalidAction, @task.errors
    end
  end

  # DELETE  /api/v1/tasks/1
  def destroy
    # @task.destroy
    @task.update({ is_active: false })
    json_response message: "success"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:data).permit(:title, :description, :sprint_id, :is_completed)
  end
end
