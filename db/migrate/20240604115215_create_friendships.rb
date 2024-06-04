class CreateFriendships < ActiveRecord::Migration[7.1]
  def change
    create_table :friendships do |t|
      t.references :member, null: false, foreign_key: true
      t.references :friend, null: false, foreign_key: { to_table: :members }

      t.timestamps
    end

    add_index :friendships, [:member_id, :friend_id], unique: true
  end
end
