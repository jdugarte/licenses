class AddIndexes < ActiveRecord::Migration
  def change
    add_index :users, :distributor_id
    add_index :distributors, :distributor_id
    add_index :clients, :distributor_id
  end
end
