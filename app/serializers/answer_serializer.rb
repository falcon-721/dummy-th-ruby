class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :question_id, :best
end
