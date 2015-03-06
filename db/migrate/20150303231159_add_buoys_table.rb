class AddBuoysTable < ActiveRecord::Migration
  def change
    create_table :buoys do |t|
      t.float :latitude
      t.float :longitude
      t.string :name
      t.string :symbol
    end
  end
end
