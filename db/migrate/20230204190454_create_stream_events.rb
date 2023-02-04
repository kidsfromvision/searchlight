class CreateStreamEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :stream_events do |t|
      t.timestamps
    end

    add_reference :stream_events, :song
    add_foreign_key :stream_events, :songs

    add_column :stream_events, :provider, :integer, default: 0
    add_column :stream_events, :status, :integer, default: 0
  end
end
