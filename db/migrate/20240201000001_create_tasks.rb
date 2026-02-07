# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.integer :status, default: 0, null: false
      t.integer :priority, default: 1, null: false
      t.date :due_date
      t.references :project, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end

    add_index :tasks, :status
    add_index :tasks, :priority
    add_index :tasks, :due_date
  end
end
