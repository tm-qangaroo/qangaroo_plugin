class RenameServiceAssociationKey < ActiveRecord::Migration
  def change
    rename_column :qangaroo_issues, :service_id, :qangaroo_service_id
  end
end
