class AddWeightCrimeWeightHealthWeightEntertainmentToPlaceDatum < ActiveRecord::Migration
  def change
    add_column :place_data, :crime_weight, :integer
    add_column :place_data, :health_weight, :integer
    add_column :place_data, :entertainment_weight, :integer
  end
end
