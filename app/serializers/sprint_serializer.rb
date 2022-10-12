class SprintSerializer < ActiveModel::Serializer
  # include FastJsonapi::ObjectSerializer
  attributes :id, :title, :description, :start_date, :end_date, :is_active

  has_many :tasks, serializer: TaskSerializer
end
