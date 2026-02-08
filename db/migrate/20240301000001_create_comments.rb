# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :task, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :comments, [:task_id, :created_at]
  end
end
