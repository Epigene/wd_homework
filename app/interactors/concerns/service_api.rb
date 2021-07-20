# frozen_string_literal: true

# Allows operation to be called with the class-level .call method
# instead of instance level #call. Eases testing.
module ServiceApi
  extend ActiveSupport::Concern

  # Module for class method definitions
  module ClassMethods
    # wraps instance #call
    def call(**options, &block)
      new(**options).call(&block)
    end
  end
end
