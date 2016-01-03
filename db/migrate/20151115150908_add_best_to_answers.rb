class AddBestToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :best, :boolean, default: false, null: false
  end
end
