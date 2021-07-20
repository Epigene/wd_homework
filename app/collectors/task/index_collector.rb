# frozen_string_literal: true

# Task::IndexCollector.call(params: params)
class Task::IndexCollector
  include ServiceApi
  include CursorPagination

  private

    def base_collection
      Task.all
    end
end
