class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.timestamps
    end

    add_reference :invitations, :label
    add_reference :invitations, :user

    add_foreign_key :invitations, :labels
    add_foreign_key :invitations, :users

    add_column :invitations, :status, :integer, default: 0
  end
end
