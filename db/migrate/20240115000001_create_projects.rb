# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description
      t.integer :status, default: 0, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :projects, %i[user_id name], unique: true
    add_index :projects, :status
    add_index :projects, :updated_at
  end
end
