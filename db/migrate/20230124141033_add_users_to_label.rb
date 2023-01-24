class AddUsersToLabel < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :label
  end
end
