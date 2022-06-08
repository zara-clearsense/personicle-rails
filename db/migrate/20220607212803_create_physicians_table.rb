class CreatePhysiciansTable < ActiveRecord::Migration[6.0]
  def change
    create_table :physicians do |t|
      t.string :user_id
      t.string :name
      t.string :first_name
      t.string :last_name
      t.timestamps
    end
  end
end
