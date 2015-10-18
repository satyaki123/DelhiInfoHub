class RemoveWeightFromPlaceDatum < ActiveRecord::Migration
  def change
    remove_column :place_data, :weight, :string
  end
end
