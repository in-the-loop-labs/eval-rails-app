# SPDX-License-Identifier: MIT
# frozen_string_literal: true

module CommentsHelper
  # Simple markdown-like formatting for comment bodies
  def format_comment_body(text)
    return "" if text.blank?

    formatted = text.dup
    formatted.gsub!(/\*\*(.+?)\*\*/, '<strong>\1</strong>')
    formatted.gsub!(/\*(.+?)\*/, '<em>\1</em>')
    formatted.gsub!(/`(.+?)`/, '<code>\1</code>')
    formatted.gsub!(/\n/, '<br>')
    formatted
  end
end
