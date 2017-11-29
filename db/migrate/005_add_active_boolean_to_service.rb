class AddActiveBooleanToService < ActiveRecord::Migration
  def up
    add_column :services, :active, :boolean, default: true
  end

  def down
    remove_column :services, :active
  end
end
