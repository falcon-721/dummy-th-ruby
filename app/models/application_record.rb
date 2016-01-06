class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def private_pub_channel
    "/#{self.class.name.pluralize.underscore}/#{id}"
  end
end
