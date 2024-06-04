class AddGinIndexToHeadlinesContent < ActiveRecord::Migration[7.1]
  def change
    add_index :headlines, :content, using: :gin, opclass: :gin_trgm_ops
  end
end
