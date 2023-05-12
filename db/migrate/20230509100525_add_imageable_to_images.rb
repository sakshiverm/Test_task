class AddImageableToImages < ActiveRecord::Migration[6.0]
  def change
    add_reference :images, :imageable, polymorphic: true, null: false
  end
end
