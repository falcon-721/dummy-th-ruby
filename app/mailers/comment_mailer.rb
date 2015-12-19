class CommentMailer < ActionMailer::Base
  default from: 'info@th.com'
  layout "mail"

  def comment_created(comment)
    @commentable = comment.commentable
    email = @commentable.user.email
    mail(to: email, subject: 'New Comment')
  end
end
