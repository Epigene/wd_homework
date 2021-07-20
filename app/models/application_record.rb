# frozen_string_literal: true

# abstract parent model
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # The global datetime, date and number field comparative query scope.
  # Use always and everywhere
  # Keywords mean [greater_than, greater_or_equal_than, less_than, and less_or_equal_than] respectively
  #
  # @return [QueryObject]
  def self.where_field(field, gt: nil, gte: nil, lt: nil, lte: nil)
    collection = all

    gt.present? &&
      collection = collection.where("#{table_name}.#{field} > ?", gt)

    gte.present? &&
      collection = collection.where("#{table_name}.#{field} >= ?", gte)

    lt.present? &&
      collection = collection.where("#{table_name}.#{field} < ?", lt)

    lte.present? &&
      collection = collection.where("#{table_name}.#{field} <= ?", lte)

    collection
  end

  singleton_class.__send__(:alias_method, :stamp, :where_field)
end
