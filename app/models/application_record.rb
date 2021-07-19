# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # The global datetime, date and number field comparative query scope.
  # Use always and everywhere
  # Keywords mean [greater_than, greater_or_equal_than, less_than, and less_or_equal_than] respectively
  #
  # @return [QueryObject]
  # rubocop:disable Metrics/ParameterLists,Naming/MethodParameterName
  def self.where_field(field, gt: nil, gte: nil, lt: nil, lte: nil)
    collection = all

    if gt.present?
      collection = collection.where("#{ table_name }.#{ field } > ?", gt)
    end

    if gte.present?
      collection = collection.where("#{ table_name }.#{ field } >= ?", gte)
    end

    if lt.present?
      collection = collection.where("#{ table_name }.#{ field } < ?", lt)
    end

    if lte.present?
      collection = collection.where("#{ table_name }.#{ field } <= ?", lte)
    end

    collection
  end
  # rubocop:enable Metrics/ParameterLists,Naming/MethodParameterName

  singleton_class.__send__(:alias_method, :stamp, :where_field)
end
