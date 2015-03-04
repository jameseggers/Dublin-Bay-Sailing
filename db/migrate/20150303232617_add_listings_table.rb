class AddListingsTable < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :buoy_listing
      t.integer :course_id
    end
  end
end
