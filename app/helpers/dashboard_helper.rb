# SPDX-License-Identifier: MIT
# frozen_string_literal: true

module DashboardHelper
  def priority_badge_color(priority)
    case priority.to_s
    when "urgent" then "danger"
    when "high" then "warning"
    when "medium" then "info"
    when "low" then "secondary"
    else "light"
    end
  end
end
