class CreateChartmetricApiTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :chartmetric_api_tokens do |t|
      t.string :token
      t.timestamp :expiry

      t.timestamps
    end
  end
end
