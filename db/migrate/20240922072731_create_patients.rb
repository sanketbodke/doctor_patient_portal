# frozen_string_literal: true

class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.string :name
      t.string :age
      t.string :phone_no
      t.string :disease
      t.references :doctor, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
