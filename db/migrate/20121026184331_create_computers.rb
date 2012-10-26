class CreateComputers < ActiveRecord::Migration
  def change
    create_table :computers do |t|
      t.references :client
      t.string :name, :default => ""
      t.integer :hd_volumen_serial, :motherboard_bios, :cpu, :hard_drive, 
                :limit => 4, :default => 0
      t.timestamps
    end
    add_index :computers, :client_id
  end
end
