class CreatePlaceData < ActiveRecord::Migration
  def change
    create_table :place_data do |t|
      t.string :place_name
      t.string :lat
      t.string :long
      t.string :weight

      t.timestamps
    end
  end
end
