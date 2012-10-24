class AddDistributorToUser < ActiveRecord::Migration
  def change
    add_column :users, :distributor_id, :integer
  end
end
