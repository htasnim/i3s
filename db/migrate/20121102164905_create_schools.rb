class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :school_name
      t.string :school_address
      t.integer :max_students

      t.timestamps
    end
  end
end
