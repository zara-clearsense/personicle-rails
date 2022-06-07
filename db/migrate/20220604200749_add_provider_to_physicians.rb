class AddProviderToPhysicians < ActiveRecord::Migration[6.0]
  def change
    add_column :physicians, :provider, :string
  end
end
