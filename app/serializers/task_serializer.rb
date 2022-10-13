class TaskSerializer < ActiveModel::Serializer
  # include FastJsonapi::ObjectSerializer
  attributes :id, :title, :description, :is_completed, :is_active
  has_one :sprint
end
