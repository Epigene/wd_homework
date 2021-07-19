# frozen_string_literal: true

# Incude in controllers whose #index action will use cursor-style pagination.
# Exposes page[size], page[after], and page[before] query params.
#
# Range pagination is not supported by default.
# Override #validate_no_range_pagination to do nothing if supported is developed.
module CursorPagination
  extend ActiveSupport::Concern

  DEFAULT_PAGE_SIZE = 10
  MAX_PAGE_SIZE = 50

  included do
    # before_action :validate_page_size, only: :index
    # before_action :validate_pagination_cursor, only: :index
    # before_action :validate_no_range_pagination, only: :index
  end

  private

    ORDERING_TO_QUERY_MAPPING = {
      asc: :gt,
      desc: :lt
    }.freeze

    # Supports naive cursor-pagination by a single unique parameter, like :id.
    def page_records_by_single_cursor(collection:, cursor_field: :id, regular_order: :asc, reverse_order: :desc)
      collection =
        if params.dig(:page, :after).present?
          collection.where_field(
            cursor_field,
            ORDERING_TO_QUERY_MAPPING[regular_order] => params.dig(:page, :after)
          )
        elsif params.dig(:page, :before).present?
          before_page_ids =
            collection.
            where_field(
              cursor_field,
              ORDERING_TO_QUERY_MAPPING[reverse_order] =>
                params.dig(:page, :before)
            ).
            # crucial to order reversely than the final order
            order(cursor_field => reverse_order).
            limit(page_size).select(cursor_field)

          collection.where(cursor_field => before_page_ids)
        else
          collection
        end

      collection.order(cursor_field => regular_order).limit(page_size)
    end

    def page_size
      @page_size ||=
        params.dig(:page, :size).presence ||
        __send__(:class)::DEFAULT_PAGE_SIZE
    end

    def validate_page_size
      size = params.dig(:page, :size)
      return if size.blank?

      unless size.match?(POSITIVE_INTEGER_REGEX)
        return render(json: non_positive_page_size_error_data, status: :bad_request)
      end

      if size.to_i > send(:class)::MAX_PAGE_SIZE
        return render(json: too_large_page_size_error_data, status: :bad_request)
      end

      nil
    end

    def validate_pagination_cursor
      after_cursor = params.dig(:page, :after)

      if after_cursor.present? && !after_cursor.match?(POSITIVE_INTEGER_REGEX)
        return render(json: non_positive_cursor_error_data(:after), status: :bad_request)
      end

      before_cursor = params.dig(:page, :before)

      if before_cursor.present? && !before_cursor.match?(POSITIVE_INTEGER_REGEX)
        return render(json: non_positive_cursor_error_data(:before), status: :bad_request)
      end

      nil
    end

    def validate_no_range_pagination
      after_cursor = params.dig(:page, :after)
      before_cursor = params.dig(:page, :before)

      return unless after_cursor.present? && before_cursor.present?

      render(json: range_pagination_error_data, status: :bad_request)
    end

    def range_pagination_error_data
      {
        "errors" => [
          {
            "title" => "Range pagination not supported.",
            "detail" =>
              "Both page[before] and page[after] supplied "\
              "where only one at a time is expected",
            "source" => {"parameter" => "page"},
            "status" => "400",
            "links" => {
              "type" => [
                "https://jsonapi.org/profiles/ethanresnick/cursor-pagination/range-pagination-not-supported"
              ]
            }
          }
        ]
      }
    end

    def non_positive_page_size_error_data
      {
        "errors" => [
          {
            "title" => "Page size requested is non-positive.",
            "detail" =>
              "page[size] must be a positive integer; "\
              "got '#{params.dig(:page, :size)}'",
            "source" => {"parameter" => "page[size]"},
            "status" => "400"
          }
        ]
      }
    end

    # @mode [Symbol] # one of [:before, :after]
    def non_positive_cursor_error_data(mode)
      {
        "errors" => [
          {
            "detail" =>
              "page[#{mode}] must be a positive integer; "\
              "got '#{params.dig(:page, mode)}'",
            "source" => {"parameter" => "page[#{mode}]"},
            "status" => "400",
            "title" => "Pagination cursor is non-positive."
          }
        ]
      }
    end

    def too_large_page_size_error_data
      {
        "errors" => [
          {
            "meta" => {
              "page" => {"maxSize" => __send__(:class)::MAX_PAGE_SIZE}
            },
            "title" => "Page size requested is too large.",
            "detail" =>
              "Page of size #{params.dig(:page, :size)} was requested, "\
              "but #{__send__(:class)::MAX_PAGE_SIZE} is the maximum.",
            "source" => {"parameter" => "page[size]"},
            "status" => "400",
            "links" => {
              "type" => [
                "https://jsonapi.org/profiles/ethanresnick/cursor-pagination/max-size-exceeded"
              ]
            }
          }
        ]
      }
    end
end
