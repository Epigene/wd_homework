# frozen_string_literal: true

class Tag::IndexCollector
  include ServiceApi
  include CursorPagination

  def initialize(params:)
    @params = params
  end

  def call

  end
end
