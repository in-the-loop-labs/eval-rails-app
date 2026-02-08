# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.references :actor, null: false, foreign_key: { to_table: :users }
      t.references :task, null: false, foreign_key: true
      t.string :action, null: false
      t.text :message, null: false
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
