class CreateCheckIns < ActiveRecord::Migration[7.0]
  def change
    create_table :check_ins do |t|
      t.string :name
      t.text :description
      t.float :latitude
      t.float :longitude
      t.float :accuracy

      t.timestamps
    end
  end
end
