class CreateHeadlines < ActiveRecord::Migration[7.1]
  def change
    create_table :headlines do |t|
      t.references :member, null: false, foreign_key: true
      t.string :content, null: false
      t.string :level, null: false

      t.timestamps
    end
  end
end
