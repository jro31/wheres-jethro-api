class AddIconToCheckIns < ActiveRecord::Migration[7.0]
  def change
    add_column :check_ins, :icon, :string
  end
end
