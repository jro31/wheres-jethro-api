class AddTimeZoneToCheckIn < ActiveRecord::Migration[7.0]
  def change
    add_column :check_ins, :time_zone, :string
  end
end
