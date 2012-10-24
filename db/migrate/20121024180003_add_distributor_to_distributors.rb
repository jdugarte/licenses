class AddDistributorToDistributors < ActiveRecord::Migration
  def change
    add_column :distributors, :distributor_id, :integer
  end
end
