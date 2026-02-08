# SPDX-License-Identifier: MIT
# frozen_string_literal: true

module Paginatable
  extend ActiveSupport::Concern

  private

  def paginate(scope, per_page: 10)
    per_page = [per_page.to_i, 1].max
    per_page = [per_page, 100].min
    page = [params[:page].to_i, 1].max

    total_count = scope.count
    total_pages = (total_count.to_f / per_page).ceil
    page = [page, [total_pages, 1].max].min

    offset = (page - 1) * per_page

    @page = page
    @per_page = per_page
    @total_pages = total_pages
    @total_count = total_count

    scope.offset(offset).limit(per_page)
  end
end
