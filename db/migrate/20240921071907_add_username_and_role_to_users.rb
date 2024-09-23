# frozen_string_literal: true

class AddUsernameAndRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    add_column :users, :role, :string
  end
end
