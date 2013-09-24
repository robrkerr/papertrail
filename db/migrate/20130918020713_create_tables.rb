class CreateTables < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :root_point_id

      t.timestamps
    end

    create_table :points do |t|
      t.integer :context_id
      t.integer :document_id
      t.text :text

      t.timestamps
    end

    create_table :subpointlinks do |t|
      t.integer :point_id
      t.integer :subpoint_id
      t.integer :position

      t.timestamps
    end
    add_index :subpointlinks, :point_id
    add_index :subpointlinks, :subpoint_id

    create_table :contexts do |t|
      t.string :description

      t.timestamps
    end
  end
end
