class AddQuestionsToPhysicians < ActiveRecord::Migration[6.0]
  def change
    add_column :physicians, :questions, :json, default: {}
  end
end
