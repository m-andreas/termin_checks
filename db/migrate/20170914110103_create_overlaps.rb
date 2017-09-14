class CreateOverlaps < ActiveRecord::Migration[5.1]
  def change
    create_table :overlaps do |t|
      t.integer :course1_id
      t.integer :course2_id
      t.string :text

      t.timestamps
    end
  end
end
