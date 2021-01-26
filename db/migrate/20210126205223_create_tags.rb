class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :places do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :albums_tags, id: false do |t|
      t.belongs_to :album
      t.belongs_to :tag
    end

    create_table :photos_tags, id: false do |t|
      t.belongs_to :photo
      t.belongs_to :tag
    end

    create_table :albums_places, id: false do |t|
      t.belongs_to :album
      t.belongs_to :place
    end

    create_table :photos_places, id: false do |t|
      t.belongs_to :photo
      t.belongs_to :place
    end
  end
end
