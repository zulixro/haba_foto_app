class AddAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
      t.string :external_id, unique: true, null: false
      t.string :title
      t.integer :year
      t.string :author
      t.date :start_date
      t.date :end_date
      t.string :cover_photo_url
      t.boolean :agreed_to_publish, default: false

      t.timestamps null: false
    end

    add_index :albums, :external_id
  end
end
