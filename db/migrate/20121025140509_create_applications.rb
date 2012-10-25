class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :name, :default => ""
      t.string :ProgramID, :default => ""
      t.decimal :price, :precision => 8, :scale => 2, :default => 0.00

      t.timestamps
    end
  end
end
