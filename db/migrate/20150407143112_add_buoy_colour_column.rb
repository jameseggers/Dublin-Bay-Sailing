class AddBuoyColourColumn < ActiveRecord::Migration
  def change
    add_column :buoys, :buoy_colour, :string
  end
end
