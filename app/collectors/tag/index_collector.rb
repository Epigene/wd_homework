# frozen_string_literal: true

# Tag::IndexCollector.call(params: params)
class Tag::IndexCollector
  include ServiceApi
  include CursorPagination

  private

    def base_collection
      Tag.all
    end
end
