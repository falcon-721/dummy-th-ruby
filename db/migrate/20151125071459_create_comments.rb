class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.belongs_to :user, index: true, foreign_key: true
      t.integer :commentable_id
      t.string :commentable_type

      t.timestamps null: false
    end

    add_index :votes, [:voteable_id, :voteable_type]
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
