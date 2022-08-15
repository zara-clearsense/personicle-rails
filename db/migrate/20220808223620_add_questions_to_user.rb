class AddQuestionsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :questions, :json, default: {}
  end
end
