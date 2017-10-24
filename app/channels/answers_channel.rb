class AnswersChannel < ApplicationCable::Channel
  def subscribed
    reject if params['id'].blank?
    stream_from "questions/#{params['id']}/answers"
  end

  def follow(params)
    stop_all_streams
    stream_from "questions/#{params['id']}/answers"
  end
end
