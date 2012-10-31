class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.references :license, :application, :computer
      t.string :sitecode, :limit => 8, :default => ""
      t.string :mid, :limit => 19, :default => ""
      t.string :activation_code, :limit => 35, :default => ""
      t.string :removal_code, :limit => 8, :default => ""
      t.integer :hd_volumen_serial, :motherboard_bios, :cpu, :hard_drive, 
                :limit => 4, :default => 0
      t.text :notes, :removal_reason
      t.integer :status, :limit => 1, :default => 0
      t.datetime :processing_date
      t.references :user
      t.timestamps
    end
    add_index :movements, :license_id
    add_index :movements, :application_id
    add_index :movements, :computer_id
    add_index :movements, :user_id
  end
end
