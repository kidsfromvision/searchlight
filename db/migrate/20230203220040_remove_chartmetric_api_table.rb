class RemoveChartmetricApiTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :chartmetric_api_tokens
  end
end
