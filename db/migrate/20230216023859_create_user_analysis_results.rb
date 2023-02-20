class CreateUserAnalysisResults < ActiveRecord::Migration[6.0]
  def change
    create_table :user_analysis_results, if_not_exists: true do |t|
      t.string "user_id", null:false
      t.string "correlation_result", null: false
      t.string "unique_analysis_id", null: false
      t.datetime "timestamp_added", null: false
      t.boolean "viewed", null:false
      t.timestamps
    end
  end
end


