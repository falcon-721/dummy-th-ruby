class AnswersChannel < ApplicationCable::Channel
  def follow(params)
    reject if params['id'].blank?
    stream_from "questions/#{params['id']}/answers"
  end
end
