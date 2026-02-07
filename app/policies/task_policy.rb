# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class TaskPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    owner_or_assignee?
  end

  def destroy?
    project_owner?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  private

  def project_owner?
    record.project.user_id == user.id
  end

  def owner_or_assignee?
    project_owner? || record.user_id == user.id
  end
end
