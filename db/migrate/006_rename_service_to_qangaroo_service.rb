class RenameServiceToQangarooService < ActiveRecord::Migration
  def up
    rename_table :services, :qangaroo_services
  end

  def down
    rename_table :qangaroo_services, :services
  end
end
