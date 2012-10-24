class AddMainToDistributors < ActiveRecord::Migration
  def change
    add_column :distributors, :main, :boolean, :default => false
  end
end
