class ChangeSongPinnedDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :songs, :pinned, false
  end
end
