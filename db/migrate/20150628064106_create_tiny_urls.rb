class CreateTinyUrls < ActiveRecord::Migration
  def change
    create_table :tiny_urls do |t|
      t.string :url
      t.string :slug, limit: 8
      t.references :owner, polymorphic: true, index: true

      t.timestamps null: false
    end
    add_index :tiny_urls, :slug, unique: true
  end
end
