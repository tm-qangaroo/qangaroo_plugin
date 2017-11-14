class AddAssociationToService < ActiveRecord::Migration
  def up
    add_column :qangaroo_issues, :service_id, :integer
  end

  def down
    remove_column :qangaroo_issues, :service_id
  end
end
