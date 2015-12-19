class Vote < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :user_id, :value, :voteable_id, presence: true
end
