class AddIndexToPhysicans < ActiveRecord::Migration[6.0]
  def change
    add_index :physicians, :uid
    add_index :physicians, :provider
  end
end
