class AddAssociationToUser < ActiveRecord::Migration
  def up
    add_column :services, :user_id, :integer
  end

  def down
    remove_column :services, :user_id
  end
end
