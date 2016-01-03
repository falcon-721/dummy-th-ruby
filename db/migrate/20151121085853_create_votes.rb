class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.integer :value, default: 0, null: false
      t.integer :votable_id
      t.string  :votable_type

      t.timestamps null: false
    end

    add_index :votes, [:votable_id, :votable_type]
  end
end
