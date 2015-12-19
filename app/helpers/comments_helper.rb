module CommentsHelper
  def comment_path_to(obj)
    question_comments_path obj.id
  end
end
