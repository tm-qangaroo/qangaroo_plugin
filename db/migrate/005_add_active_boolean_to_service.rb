class AddActiveBooleanToService < ActiveRecord::Migration[4.2]
  def up
    add_column :services, :active, :boolean, default: true
  end

  def down
    remove_column :services, :active
  end
end
