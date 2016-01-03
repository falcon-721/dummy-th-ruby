class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :user_id, :body, :commentable_id, presence: true

  after_create :notify_author

  private

  def notify_author
    CommentMailer.comment_created(self).deliver_later
  end
end
