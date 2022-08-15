class CreateInsightsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :insights do |t|
      t.string "user_id",  null: false
      t.string "life_aspect",  default: "", null: false
      t.string  "impact", default: "", null: false
      t.string "insight_text", default: "", null: false
      t.datetime "expiry_time"
      t.boolean "viewed", null: false, default: false
      t.timestamps
    end
  end
end
