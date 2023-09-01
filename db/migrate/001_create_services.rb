class CreateServices < ActiveRecord::Migration[4.2]
  def change
    create_table :services do |t|
      t.string    :name
      t.string    :api_key
      t.string    :namespace
      t.timestamps
    end
  end
end
