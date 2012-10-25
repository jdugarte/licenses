class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name, :default => ""
      t.string :email, :default => ""
      t.belongs_to :distributor

      t.timestamps
    end
  end
end
