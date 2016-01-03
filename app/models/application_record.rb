class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def serialized
    active_model_serializer.new(self)
  end

  def private_pub_channel
    "/#{self.class.model_name.pluralize.underscore}/#{id}"
  end
end
