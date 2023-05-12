class RemoveRefInProducts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :products, :categories, foreign_key: true, index: false
  end
end
