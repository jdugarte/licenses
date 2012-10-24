class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, :default => false
    User.all.each do |user|
      user.update_attributes! :admin => true
    end
  end
end
