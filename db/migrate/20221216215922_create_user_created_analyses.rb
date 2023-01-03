class CreateUserCreatedAnalyses < ActiveRecord::Migration[6.0]
  def change
    create_table :user_created_analyses, if_not_exists: true do |t|
      t.string "user_id", null: false
      t.string "unique_analysis_id"
      t.string "anchor", null: false
      t.string "antecedent_name", null: false
      t.string "antecedent_table", null: false
      t.string "antecedent_parameter"
      t.string "consequent_name", null: false
      t.string "consequent_table", null: false
      t.string "consequent_parameter"
      t.string "aggregate_function", null: false
      t.string "antecedent_type", null: false
      t.string "consequent_type", null: false
      t.string "consequent_interval"
      t.string "antecedent_interval"
      t.string "query_interval"
      t.timestamps
    end
  end
end
