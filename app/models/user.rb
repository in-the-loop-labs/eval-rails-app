# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :projects, dependent: :destroy
  has_many :assigned_tasks, class_name: "Task", dependent: :nullify
  has_many :comments, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :email, length: { maximum: 255 }

  # Scopes
  scope :alphabetical, -> { order(:name) }
  scope :recently_created, -> { order(created_at: :desc) }

  def display_name
    name.presence || email
  end
end
