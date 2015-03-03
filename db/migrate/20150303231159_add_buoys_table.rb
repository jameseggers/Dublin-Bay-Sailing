class AddBuoysTable < ActiveRecord::Migration
  def change
    create_table :buoys do |t|
      t.string :latitude
      t.string :longitude
      t.string :name
      t.string :symbol
    end
  end
end
