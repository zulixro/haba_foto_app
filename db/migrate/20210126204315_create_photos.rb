class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.belongs_to :album, foreign_key: true
      t.string :external_id, unique: true, null: false
      t.string :author
      t.date :date

      t.timestamps null: false
    end

    add_index :photos, :external_id
  end
end
