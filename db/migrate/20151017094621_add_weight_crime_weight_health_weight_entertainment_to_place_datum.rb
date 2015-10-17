class AddWeightCrimeWeightHealthWeightEntertainmentToPlaceDatum < ActiveRecord::Migration
  def change
    add_column :place_data, :crime_weight, :string
    add_column :place_data, :health_weight, :string
    add_column :place_data, :entetainment_weight, :string
  end
end
