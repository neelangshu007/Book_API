class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :language
      t.integer :price
      t.string :author
      t.string :isbn

      t.timestamps
    end
  end
end
