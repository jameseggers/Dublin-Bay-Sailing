class AddCourseTable < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :symbol
      t.integer :wind_direction
      t.timestamps
    end
  end
end
