class AddUserIdToAnswers < ActiveRecord::Migration
  def change
    add_reference :answers, :user, index: true, foreign_key: true
  end
end
