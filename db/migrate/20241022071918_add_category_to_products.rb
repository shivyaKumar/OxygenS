class AddCategoryToProducts < ActiveRecord::Migration[6.1]
  def change
    # Allow null for now, so the migration won't fail
    add_reference :products, :category, foreign_key: true, null: true
  end
end