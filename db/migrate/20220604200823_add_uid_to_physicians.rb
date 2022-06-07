class AddUidToPhysicians < ActiveRecord::Migration[6.0]
  def change
    add_column :physicians, :uid, :string
  end
end
