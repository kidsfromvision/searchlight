class CreateApiTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :api_tokens do |t|
      t.string :token
      t.timestamp :expires_at

      t.timestamps
    end
  end
end
