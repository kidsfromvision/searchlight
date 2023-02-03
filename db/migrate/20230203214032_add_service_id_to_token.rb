class AddServiceIdToToken < ActiveRecord::Migration[7.0]
  def change
    add_column :api_tokens, :provider, :integer, required: true
  end
end
