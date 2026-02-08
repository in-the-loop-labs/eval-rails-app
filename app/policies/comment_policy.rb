# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def create?
    true
  end

  def edit?
    owner?
  end

  def update?
    owner?
  end

  def destroy?
    owner? || project_owner?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  private

  def owner?
    record.user_id == user.id
  end

  def project_owner?
    record.task.project.user_id == user.id
  end
end
