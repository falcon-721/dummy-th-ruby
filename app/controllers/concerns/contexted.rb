module Contexted
  extend ActiveSupport::Concern

  protected

  def set_context
    return @context = current_user if params[:context] == 'user'
    @context = context_resource.find(context_id)
    instance_variable_set("@#{params[:context]}", @context)
  end

  private

  def context_resource
    params[:context].classify.constantize
  end

  def context_id
    params.fetch("#{params[:context].foreign_key}")
  end
end
